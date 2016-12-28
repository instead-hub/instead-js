--
-- Created by IntelliJ IDEA.
-- User: epoxa
-- Date: 30.05.15
--

-- Специальные диалоги

dlg = hook(dlg, function(f, init, ...)
  if not init.phr then
    init.phr = {};
  end
  init.update = function(s, restart)
    --    print("STAGE: " .. s._stage);
    local r, v;
    --    pon(s._stage);
    for r, v in opairs(s.obj) do
      if isPhrase(v) then
        if restart or not isRemoved(v) then
          if v.tag == s._stage then
            local en = true;
            if en and v.cond then
              en = stead.call(v, 'cond');
            end
            if en then
              --            pon(v);
              v:enable();
            else
              --            poff(v);
              disable(v);
            end
          else
            --          poff(v);
            disable(v);
          end
        end
      end
    end
  end
  if init.talk then
    local traverse = function(sf, root, phrases, stage, idx, persist)
      local text = root[1];
      local childrenStage;
      if root.stage then
        childrenStage = root.stage;
      else
        childrenStage = stage .. '-' .. idx;
      end
      if root.persist == false then
        persist = false;
      elseif root.persist == true then
        persist = true;
      end
      local ph = {
        tag = stage,
        false,
        always = true,
        text,
        function(s)
          local w = here();
          poff(w._stage);
          w._stage = childrenStage;
          if not persist then
--            prem(s);
            s:remove();
          end
          if root.act then
            local v, r = stead.call(root, 'act');
            w:update();
            return v, r;
          else
            p(text);
            w:update();
          end
        end,
        --        _hide = false;
      }
      if root.cond then
        ph['cond'] = root.cond;
      end
      stead.table.insert(phrases, ph);
      -- Обработаем все возможные фразы-ответы
      for k, v in ipairs(root) do
        if k ~= 1 then
          sf(sf, v, phrases, childrenStage, k, persist);
        end
      end
    end
    for k, v in ipairs(init.talk) do
      traverse(traverse, v, init.phr, 'top', k, false);
    end
  end
  -- TODO: Ужас какой, четыре раза дублируется!
  if init.enter then
    init.enter = stead.hook(init.enter, function(f, s, ...)
      local r = f(s, ...);
      s._stage = 'top'
      print "ENTERED DLG";
      s:update();
      return r;
    end)
  else
    init.enter = function(s)
      s._stage = 'top'
      s:update();
    end
  end
  if init.left then
    init.left = stead.hook(init.left, function(f, s, ...)
      local r = f(s, ...);
      s._stage = 'top'
      s:update();
      return r;
    end)
  else
    init.left = function(s)
      s._stage = 'top'
      s:update();
    end
  end
  init._stage = 'top';
  init.hideinv = true;
  local o = f(init, ...);
  o.ext_dlg_type = true;
  o:update();
  return o;
end);
