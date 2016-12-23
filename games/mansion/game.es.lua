global { track_time = 0 };

music_player = obj {
	nam = 'player';
	var { pos = 15; };
	playlist = { '01.ogg', 0,
		'02.ogg', 0,
		'03.ogg', 0,
		'04.ogg', 0,
		'05.ogg', 0,
		'06.ogg', 1,
		'07.ogg', 0,
		'08.ogg', 0,
		'09.ogg', 0,
		'10.ogg', 1,
		'11.ogg', 0,
		'12.ogg', 0,
		'13.ogg', 0,
		'14.ogg', 0,
		'15.ogg', 1},
	life = function(s)
		if here() == entrance or here() == sside or here() == nside or here() == atmansion then
			add_sound('snd/rain.ogg', 5, 0);
		else
			stop_sound(5);
		end
		if is_music() and ( track_time < 120 or not player_moved() ) then
			return
		end
		track_time = 0
		s.pos = s.pos + 2
		if s.pos > #s.playlist then
			s.pos = 1
		end
		set_music('mus/'..s.playlist[s.pos], s.playlist[s.pos + 1]);
	end
}

game.timer = function(s)
	track_time = track_time + 1
	music_player:life();
end

timer:set(1000)

lifeon(music_player);
function start()
	music_player:life()
end
global { gameover = false }

function takeit(txt)
	return function(s)
		p (txt);
		return true;
	end
end

function lifeonf(s)
	game.lifes:add(s, 1);
end

game.use = function(s, w, o)
	if w.nouse then
		return call(w, 'nouse');
	end
	if o.noused then
		return call(o, 'noused');
	end
	return 'Creo que esto no va a ayudar ...'
end

room = stead.inherit(room, function(v)
	v.dsc = stead.hook(v.dsc, function(f, s,...)
		if s.dsc1 and not s._first_dsc then
			s._first_dsc = true
			return call(s, 'dsc1');
		end
		return f(s, ...);
	end)
	return v
end)

door = function(v)
	v.door_type = true
	if not v._opened then
		v._opened = false
	end
	v.useit = function(s)
		s._opened = not s._opened;
		if s._opened then
			path(s.path):enable();
			p [[Abrí la puerta.]]
		else
			path(s.path):disable();
			p [[Cerré la puerta.]]
		end
	end
	return obj(v);
end

shotgun = obj {
	nam = 'escopeta';
	var { armed = false; flash = false; };
	dsc = [[Encima de la chimenea hay una {escopeta} de caza colgado.]];
	exam = function(s)
		p 'Cañones negros bien lubricados. Una hermosa arma. En el extremo hay algo escrito en alemán. ';
		if s.flash then
			p [[Fijé la linterna con cinta al cañón]]
		end
	end;
	take = function(s)
		if on_chair then
			p [[¡El rifle es mío!]]
			return true
		else
			p [[Demasiado alto, no alcanzo]];
		end
	end;
	useit = function(s)
		if s.armed then
			p [[Arma cargada. ]]
		else
			p [[No cargada. ]];
		end
	end;
	shot = function(s)
		s.armed = false
		add_sound 'snd/gun.ogg'
	end;
	use = function(s, w)
		if w == card then
			if w.locked then
				p [[Golpeé la culata contra el cristal. 
                                El vidrio cedió. Empujé suavemente 
                                la mano y abrí la puerta desde el interior./]]
				w.locked = false
				add_sound 'snd/glass.ogg'
				return
			end
			p [[Abrí la puerta]]
			return
		end

		if not s.armed then
			return [[No cargada.]], false
		end

		if w.slug_type and w:dead() then
			return [[Está muerto.]]
		end

		if w == slug2 then
			if flash.gun then
				if not flash.on then
					p [[Encendí la linterna, sujeté el rifle y apunté.]]
					flash.on = true
					lifeon(flash)
				else
					p [[Ahora puedo llevar una linterna y apuntar el rifle hacia esas cosas.]]
				end
				p [[El estruendo del doble disparo resonó en la mansión. La babosa se rompió en pedazos. ]]
				s:shot()
				slug2:kill()
				lifeoff(ladder1)
				make_snapshot()
				return
			end
			if not flash.on then
				p [[Encendí la linterna y comprobé -- la babosa estaba en su lugar. ]]
			else
				p [[Encendí la linterna en los escalones -- la babosa estaba en su lugar. ]]
			end
			p [[No podía apuntar con la mirilla a la babosa y dirigir la linterna a la vez hacia su dirección, así que tuve que quitar la linterna y disparar casi al azar. El rugido resonó por toda la casa. Miré hacia arriba por las escaleras ...]]
			flash.on = true;
			lifeon(flash)
			s:shot()
			return
		end
		if w.slug_type then
			s:shot()
			if w._dist > 2 then
				p [[Disparé a la babosa y fallé]];
				return
			end
			p [[Levanté la escopeta y apreté el gatillo. Descerrajé un tiro. Grumos verdes volaron en todas direcciones y me dí cuenta de que había caido. ]];
			w:kill();
			if here() == floor2 then
				remove(w)
				put(slug2dead)
				if slug3:dead() and slug4:dead() and slug5:dead() then
					make_snapshot()
				end
			end
			return
		end
		if w == dog then
			if not dog:dead() then
				if dog.down then
					p [[Vacié la escopeta en el monstruo muerto.]]
				else
					p [[Levanté el arma y disparé al monstruo. Continuó su carrera]]
					dog.shot = 1
				end
				s:shot();
				return
			end
		end
		if w == tdoor then
			if not dog.down then
				p [[Me apoyé en la puerta y disparé el arma ... Una nube de esquirlas me arañó la cara. ]]
				if dog.shot == 1 then
					p [[Hubo un golpe en la puerta, luego otro -- más débil. Entonces los golpes cesaron]];
					dog.down = true
					lifeoff(dog)
				else
					p [[Los golpes en la puerta se detuvieron, pero luego se reanudaron, con una explosión.]];
				end
				s:shot()
				return
			end
			p [[Parece que no hay necesidad...]]
			return
		end	
		if w == door34 then
			if not dog.down then
				return [[Me va a comer mientras yo le disparo a la puerta.]];
			end
			sleeping.broken = true
			w:disable()
			s:shot()
			return [[Disparé la escopeta hacia la cerradura de la puerta. Un golpe sordo sonó en el pasillo. ¡Funcionó!]]
		end;
		if w == spider1 then
			if w:dead() then
				return [[Queda tan poco de él.]]
			end
			s:shot()
			w:kill()
			remove(vantuz, me())
			return [[Disparo casi sin apuntar. Simplemente metiendo los cañones de la escopeta bajo la escotilla oxidada. Los restos de araña y desatascador volaron aparte. ]]
		end
		if w == luk then
			if not dog.down then
				return [[Me va a comer mientras que yo disparo hacia la escotilla.]];
			end
			s:shot()
			return [[¡Disparé la escopeta en la escotilla! Algunas esquirlas me cayeron en la mano.]]
		end;
	end;
	nouse = [[La escopeta no ayudará.]];
}

function init()
	mode_exam:ini()
end


main = room {
	nam = '';
	pic = 'gfx/intro.png';
	hideinv = true;
	dsc = function(s)
		p [[ -- Ivan, me voy a la ciudad. Me quedaré hasta mañana, no pierdas de vista a tu hermano.^
		 -- Bueno.^
		 -- No te olvides de cerrar la puerta por la noche.^
		 -- Por supuesto, padre.^
		 -- Por cierto, ¿dónde está Andrés?^
		 -- Paseando en bicicleta, lo ví hace media hora...^
		 -- Lastima, no pude decirle adiós... sigue manteniendo un ojo sobre él... vendré tan rápido como pueda...^
		 -- Todo irá bien, padre...^
		      -- bueno, me voy...]];

		if (PLATFORM == 'UNIX' or PLATFORM == 'WIN32') and theme:name() ~= '.' then
			pn()
			pn()
			p (txtem("¡¡¡ADVERTENCIA!!! Ha desactivado sus propios temas y juegos. El juego no se verá la forma en que el autor tenía la intención."));
		end
	end;
	obj =  { vway('seguir', '{seguir}', 'title') };
}

title = room {
	nam = 'INSTEAD 2011';
	pic = 'gfx/0.png';
	hideinv = true;
	dsc = [[Por la noche, cuando dieron las diez y su hermano no vino a cenar, se montó en su bici y se fué a buscarlo, creía que sabía donde podía estar. Comenzó una tormenta...]];

	obj =  { vway('seguir', '{Inicie la aventura}', 'entrance') };
}


wall = obj {
	nam = 'valla';
	dsc = [[Una {valla} alta erizada de hierros afilados. ]];
	exam = [[Varillas de acero resistente y afilados en sus extremos. ]];
	useit = function(s)
		if on_tree then
			return "Estoy en el árbol"
		end
		if velo.state == 2 then
			p [[Me subí a la bicicleta y traté de saltar por encima de la valla. Las barras de picos afilados no me dejaron hacerlo.]]
			return
		end
		p [[Traté de pasar por encima de la cerca, pero mis manos se deslizaron sobre las barras mojadas. ]];
	end;
}

vorota = obj {
	nam = 'puertas';
	dsc = [[Ante mí las {puertas} están cerradas.]];
	exam = [[Tras la puerta cuelga un enorme castillo]];
	useit = function()
		if on_tree then
			return "Estoy en el árbol. "
		end
		p [[Traté de empujar la puerta pero no cedió. ]];
	end
}

mansion = obj {
	nam = 'palacio';
	dsc = [[Veo a través de los barrotes la silueta siniestra del {palacio}.]];
	exam = [[ No hace falta decir que este edificio era un lugar tentador para un niño:
                cerrado por una alta verja de hierro, parecía ocultar un siniestro secreto ... ^
                El misterioso inquilino de la casa, al que no solíamos ver, iba a la ciudad de vez en cuando en su "ZIM-12" negro, eso era todo ... ^
                Sin embargo, en los últimos meses el edificio parecía abandonado, y ya que nadie había visto a sus habitantes abandonar la mansión, se difundieron rumores de que el inquilino fue declarado enemigo del pueblo, y se lo llevaron junto con los siervos de la noche ... ^
                Los chicos, bajando la voz, contaban historias sobre esta casa. No creo que ninguno de ellos hubiera estado realmente allí, detrás de la valla ... De todos modos, tengo que recoger a mi hermano de allí. Espero que no pase nada ...]];
}

velo = obj {
	nam = 'bicicleta';
	var { state = 1 };
	dscs = { "Bajo el árbol hay una {bicicleta}",
		"Sobre el árbol hay una {bicicleta}",
		"La {bicicleta} está en la cerca"};

	dsc = function(s)
		return s.dscs[s.state];
	end;
	exam = [[Ahora, al ver la bicicleta de mi hermano pequeño, me di cuenta de que había supuesto de antemano la partida del padre, y corrió de inmediato para la casa ... ]];

	take = function(s)
		if on_tree then
			return "Estoy en el árbol. "
		end
		s.state = 1
		p "Tomé la bicicleta."
		return true
	end;
	useit = function(s)
		if have(s) then
			return "No quiero montar..."
		end
		if s.state == 1 then
			p [[Miro pensativo a la bicicleta reclinada. ]]
		else
			p [[Miro pensativamente, de pie sobre la bicicleta.]]
		end
	end;
	use = function(s, w)
		if w == tree then
			p 'Puse la bicicleta en el árbol.'
			s.state = 2
			drop(s)
		elseif w == wall or w == vorota then
			p 'Puse la bici en la valla.'
			s.state = 3
			drop(s)
		else
			p "Extraño uso de la bicicleta..."
		end	
	end
}
global { on_tree = false };
tree = obj {
	nam = 'arbol';
	dsc = [[El viento racheado agita las hojas del {arbol}.]];
	exam = [[Se trata de un viejo roble. Retorcidas ramas entrelazadas, perdido en la bruma de la lluvia ...]];
	useit = function(s)
		if velo.state ~= 2 then
			return [[Traté de subir a un árbol, pero no podía saltar a las primeras ramas y no conseguí subir por el mojado tronco nudoso]];
		end
		if on_tree then
			path('Saltar la valla'):disable();
			on_tree = false
			return [[Bajé del árbol.]]
		end
		on_tree = true;
		path('Saltar la valla'):enable();
		return [[Levantado sobre la bicicleta, me lancé a la rama y trepé a un árbol.]]
	end
}

entrance = room {
	pic = 'gfx/1.png';
	nam = 'La valla';
	dsc = [[Me paro frente a la vieja mansión. Diluvia. La silueta del edificio parece disolverse en una nube de lluvia.]];
	way = { vroom('Saltar la valla', 'atmansion'):disable() };
	obj =  { 'wall', 'vorota', 'mansion', 'tree', 'velo' };
}

man0 = obj {
	nam = 'mansión';
        dsc = [[La {mansión} de tres pisos se eleva ante mí ominosamente.]];

	exam = [[Las ventanas de la planta baja están cerradas por enrejados. Levanté la cabeza y miré arriba. La luz de la ventana estaba apagada.]];
	useit = [[-- ¡Аndréees! -- Mi grito se perdió en la tormenta.]];
}

door0 = obj {
	nam = 'entrada';
	var { broken = false };
	dsc = [[La carretera conduce desde la cerca a las {puertas} principales,]];
	exam = function(s)
		if s.broken then
			p "Restos de la puerta aserrada tumbados en el camino.";
		else
			p "Creo que está hecho de madera de roble. En la puerta hay una aldaba.";
		end
		if cap:disabled() then
			p [[Mirando alrededor de la puerta, de repente advertí que había un objeto a mis pies...]];
			cap:enable()
		end
	end;
	useit = function(s)
		if s.broken then
			return "Seguir llamando no tiene ya sentido."
		end
		p [[La puerta estaba cerrada con llave. Llamó varias veces y esperó. Entonces empezó a golpear la puerta. Eso no ayuda.]]
	end;
};

fountain = obj {
	nam = 'fuente';
   dsc = [[bordeando la {fuente}.]];
	exam = [[Una piscina circular llena de agua, la cual parece bastante negra.]];
	useit = function(s)
		p [[Examinando cuidadosamente la fuente encontré una manguera.]];
		pipe:enable();
	end;
	obj =  { 'cap', 'pipe' };
}

cap = obj {
	nam = 'gorra';
	var { wear = false };
	dsc = [[En la escalera, en frente de la casa veo un {objeto}...]];
	take = function(s)
		p [[Me agaché y cogí algo de las escaleras. Era la gorra de mi hermano. Mi padre se la dió a Andrés recientemente. Apreté los dientes. Tendré que dársela cuando lo encuentre.]]
		return true
	end;
	exam = function(s)
		if have(s) then
			return [[La gorra de mi hermano. Tengo que devolvérsela.]]
		end
		p [[Algo pequeño.]]
	end;
	useit = function(s)
		if not have(s) then
			return [[Primero tiene que tomarlo.]]
		end
		s.wear = not s.wear;
		if s.wear then
			p [[Pensó por un momento y se puso la gorra.]];
		else
			p [[Me quité la gorra.]]
		end
	end;
	use = function(s, w)
		if w == brother then
			return [[Ahora, ya no es necesaria la gorra.]]
		end
	end;
	nouse = [[¡Esta gorra es de mi hermano! ]];
}:disable();

pipe = obj {
	nam = 'manguera';
   dsc = [[Veo una {manguera}, situada cerca de la fuente.]];
	exam = [[Manguera de goma larga conectada a la cañería cerca de la fuente. Lo más probable es que esté aquí para el riego de flores.]];
	useit = [[No tiene sentido regar las flores bajo la lluvia.]];
	take = [[Está bien sujeta al tubo y no necesito esa manguera larga.]];
}:disable();

lclumbs = obj {
	nam = 'macizo izquierdo';
	dsc = [[A {izquierda} ]];
	exam = [[En mi opinión estas flores están marchitas...]];
	take = [[No las necesito.]];
	useit = function(s)
		if not nognicy:disabled() then
			return [[Caminó a lo largo de los macizos de flores, pero no encontró nada de interés.]];
		end
		p [[Caminé a lo largo de los lechos de flores. En el suelo, junto a la carretera, encontré unas tijeras.]]
		nognicy:enable()
	end;	
}

tube = obj {
	nam = 'tubo de goma';
	exam = 'Un trozo de manguera de goma.';
	useit = [[¿Como puede usarse?]];
	use = function(s, w)
		if w == bak then
			inv():del(s)
			w.tube = true
			p [[Abro la puerta del tanque e inserto la manguera.]] 
			return
		end
		p [[¿Manguera?]]
	end
}

nognicy = obj {
	nam = 'tijeras';
   dsc = 'En los parterres de la izquierda en el suelo, hay unas {tijeras} de jardín.';
	exam = 'Tijeras de podar. Afiladas -- ¡una herramienta fiable!';
	take = takeit [[Cogí las tijeras de la tierra.]];
	useit = function(s)
		if not have(s) then
			return  [[Primero tengo que tomarlas.]]
		end
		return [[Hago chasquear las tijeras.]]
	end;
	use = function(s, w)
		if w == pipe then
			if  not taken 'tube' then
				p [[Corté un trozo de manguera con las tijeras. ]]
				take 'tube'
				return
			end
			return [[Ya no necesito una manguera.]]
		end
		if w == brother then
			if w.web then
				w.web = false
				return [[Con cierta dificultad, corté una desagradable red de filamentos.]]
			end
			return [[He liberado a mi hermano de la red.]]
		end
	end;
	nouse = [[¿Cortar?]];
}:disable();

rclumbs = obj {
	nam = 'parterre derecho';
	dsc = [[y {derecha} alrededor de la fuente veo flores. ]];
	exam = [[Parece que son rosas... ]];
	take = [[No las necesito]];
	useit = [[Caminé a lo largo de los macizos de flores, pero no encontré nada de interés. ]];
	obj = { 'nognicy' };
}

atmansion = room {
	nam = 'Antesala';
	pic = function(s)
		if door0.broken then
			return 'gfx/2b.png'
		else
			return 'gfx/2.png'
		end
	end;
	entered = function(s, f)
		if f == entrance then
			return [[Pasando a lo largo de las ramas del árbol saltó la cerca y pasó al otro lado. En el último momento se dió cuenta de que probablemente cometió el mismo error que su hermano - No había pensado en cómo volver ...^  Bueno, lo principal era encontrar a su hermano, luego ya veríamos ...]]
		end
	end;
	dsc = [[En frente de la casa.]];
	way = { vroom('Fachada Norte', 'nside'), 
		vroom('Entrada', 'inmansion'):disable(), 
		vroom('Fachada Sur', 'sside')};
	obj = { man0, door0, fountain, lclumbs, rclumbs};
}
lamberts = obj {
	nam = 'troncos';
   dsc = 'Advertí unos {troncos} cortados junto a la valla plegable.';
	exam = 'Tal vez la casa tenga una chimenea...';
	take = '¿Quiere arrastrar un tronco consigo?';
	useit = 'Empujé un par de troncos y se deslizaron hacia el suelo...';
}

pila = obj {
	nam = 'motosierra';
	var { fuel = false; on = false; };
	dsc = 'Una {motosierra} yace al lado de las maderas cortadas.';
	exam = 'Motosierra "Amistad". ¡12 Kg de peso útil!';
	take = function(s)
		p [[Tomé una motosierra.]];
		return true
	end;
	ini = function(s)
		if s.on and not gameover then
			add_sound ('snd/chain2.ogg', 3, 0)
		end
	end;
	useit = function(s)
		if not s.fuel then
			return [[Trato de arrancar la motosierra pero fallé. Mirando hacia el tanque observo con pesar que no tiene gasolina. ]]
		end
		s.on = not s.on
		if s.on then
			p [[Saqué el motor de arranque y la motosierra volvió a hacer ruido. El olor a gasolina despertó mi sed de sangre]]
			lifeon(s)
			add_sound 'snd/chain.ogg'
		else
			stop_sound(3)
			p [[Detuve la motosierra]]
			lifeoff(s)
		end
	end;
	life = function(s)
		if player_moved() then
			s.on = false
			p [[Ahogué la motosierra]]
			stop_sound(3)
			lifeoff(s)
		else
			if not gameover then
				add_sound ('snd/chain2.ogg', 3, 0)
			end
			return [[Sonido de la motosierra con motor funcionando a baja velocidad y silencioso.]]
		end
	end;
	use = function(s, w)
		if w == card then
			if w.locked then
				p [[Hice girar y mover toda la masa de la motosierra en el cristal. Por supuesto, el vidrio no pudo soportarlo. Metí la mano con cuidado y abrí la puerta desde el interior]]
				w.locked = false
				add_sound 'snd/glass.ogg'
				return
			end
			p [[Abrí la puerta]]
			return
		end
		if w == bak then
			if w.tube then
				p [[Chupé un poco de gasolina y luego metí la manguera en el tanque de la motosierra hasta llenarlo.]]
				s.fuel = true
				return
			end
			return [[Para llenar la motosierra tengo que dar la vuelta al coche... ]]
		end
		if not s.on then
			return [[La motosierra no está en marcha]], false
		end
		if w == door0 then
			if w.broken then
				p [[Lo he cortado]]
				return
			end
			p [[Sin pensarlo, me puse a cortar la puerta. La motosierra rugió, astillas y virutas volaban en mi cara, Podía oler las emisiones... Por último se me cayó la sierra. Está hecho.]]
			w.broken = true
			path 'Entrada':enable()
			add_sound 'snd/chain3.ogg'
			return
		end
		if w == kotel0 then
			return [[Contrariamente a la creencia popular, la motosierra sirve para aserrar madera, no metal. ]]
		end
		if w.door_type then
			if w.locked then
				w.locked = false
				p [[Sin pensarlo, me puse a cortar la puerta. La motosierra rugió... Cortar esta puerta fue más fácil que la de la parte delantera...]]
				return 
			end
			return [[¿Tal vez sea mejor simplemente abrir?]]
		end
		if w == vetkid then
			return "Los he cortado."
		end
		if w == vetka then
			if not vetka.seen then
			else
				p [[Golpeé con la cadena de la sierra en movimiento los tentáculos terribles que estaban apoderándose de mí. La sierra empezó a rugir, cortó los tentáculos y el agarre se fue debilitando.]];
			end
			p [[Surgió un desagradable olor agridulce, empalagoso.]]
			vetkid:enable()
			lifeoff(w);
			w:disable();
			add_sound 'snd/chain3.ogg'
			return
		end
		if nameof(w) == 'plantas' then
			if seen (vetka) then
				return '¡No se aferre a ellos!'
			end
			if not tree_attack then
				return 'Sí, no me gustan esos árboles, pero ¿porqué malgastar la gasolina?';
			end
			if tree_dead then
				return 'Ya lo hice.'
			end
			tree_dead = true
			add_sound 'snd/chain3.ogg'
			return [[Con cautela se acercó al árbol, blandiendo la motosierra lista. Las ramas retorcidas se acercaron a mí, pero yo estaba listo. La motosierra rugiente y el olor de la gasolina llena el invernadero... Después de un rato se acabó todo...]];
		end
		if w == lamberts then
			p [[No necesito leña.]]
			return
		end
		if w == kotelshelf then
			if w.broken then
				return [[No tiene sentido cortarlo.]]
			end
			w.broken = true
			add_sound 'snd/chain3.ogg'
			return [[Cortar el estante no llevó mucho tiempo.]]
		end
		if w == doska then
			return [[¿Para qué tengo que cortar el tablón?]]
		end
		if w == door34 then
			if not dog.down then
				return [[Aunque vi la puerta, voy a acabar con esa cosa.]];
			end
			sleeping.broken = true
			w:disable()
			add_sound 'snd/chain3.ogg'
			return [[Empecé a cortar la puerta. Ya tenía la experiencia, así que esta vez me las arreglé rápido]];
		end
		if w == dog then
			if dog:dead() then
				return [[No soy un carnicero.]]
			end
			if not dog.down then
				gameover = true
				lifeoff(dog)
				walkin 'dogend'
				add_sound 'snd/chain3.ogg'
				return [[Traté de alcanzar a la criatura con la motosierra ... pero era demasiado rápida y sólo pude cortarle la pierna izquierda. El enorme cuerpo cayó sobre mí ...]]
			end
			dog.killed = true
			add_sound 'snd/chain3.ogg'
			make_snapshot();
			return [[Ahora estoy seguro de que el monstruo ya no puede hacerme daño]]
		end
		if w == spider1 then
			if w:dead() then
				return [[Queda tan poco de él.]];
			end
			gameover = true
			p [[Traté de atacar a la araña con la sierra, pero no lo conseguí.]];
			lifeoff(spider1)
			stop_sound(3)
			walkin 'spiderend2'
			return 
		end
	end;
	nouse = [[La motosierra es una buena herramienta, pero aquí no ayuda.]];
}

kotel0 = obj {
	nam = 'entrada al sótano';
	var { opened = false };
	dsc = [[Aquí está la {entrada} que conduce al sótano.]];
	exam = [[Escaleras agrietadas conducen hacia abajo hasta una puerta de metal en la que pone "Caldera"]];
	useit = function(s)
		if s.opened then
			p [[La puerta se abrió. ]]
		else
			p [[La puerta está cerrada.]]
		end
	end;
}

nside = room {
	nam = 'Zona Norte';
	pic = 'gfx/3.png';
	entered = function(s, f)
		if f == atmansion then
			p [[Camino alrededor de la casa hacia el Norte.]];
		end
	end;
	obj = { 'kotel0', 'lamberts', 'pila' };
	way = { vroom('Hacia la fachada delantera', 'atmansion'), vroom('Al sótano', 'kotel'):disable() };
}

car = obj {
	nam = 'automovil';
        dsc = [[Cerca de allí, en el camino, hay un {automóvil} negro.]];
	exam = [[Gas 12. Noventa caballos de fuerza. ]];
	useit = function(s)
		if have(mkeys) then
			return [[¡Tengo la llave! pero no le dejaré aquí solo. ]];
		else
			return [[Yo no tengo las llaves del coche. ]]
		end
	end
}

bak = obj {
	nam = 'Depósito';
	var { tube = false };
	dsc = [[{Depósito} situado detrás.]];
	exam = function(s)
		if s.tube then 
			p [[Tubo saliendo del tanque. ]];
		else
			p [[Creo que el coche funciona. ]];		end
	end;
	useit = [[Miré en el tanque. Huele a gasolina ..]];

}:disable();

kuzov = obj {
	nam = 'carrocería';
   dsc = [[Los destellos de rayos resplandecen reflejados en su {carrocería} negra.]];
	exam = function(s)
		p [[En la puerta de atrás veo el tanque.]];
		bak:enable()
	end;
	obj = { 'bak' };
}

card = obj {
	nam = 'puerta del coche';
	var { locked = true; };
	dsc = [[Las manijas de cromo de la {puerta del coche} brillan incluso en la penumbra.]];
	exam = function(s)
		p [[Hermoso coche. ]];
		if not s.locked then
		   p [[Sólo tiene el vidrio rayado.]]
		end
	end;
	useit = function(s)
		if s.locked then
			p [[He probado la manilla de la puerta. Cerrado.]];
			return
		end
		if have(mkeys) then
			return [[Tengo las llaves del coche, creo que la puerta ya no es un obstáculo...  pero no voy a abandonar a mi hermano. ]];
		end
		walkin 'incar'
	end;
}

sside = room {
	nam = 'Zona Sur';
	pic = 'gfx/4.png';
	entered = function(s, f)
		if f == atmansion then
			p [[Caminé alrededor de la casa, al sur.]];
		end
	end;
	obj = { 'car', 'kuzov', 'card' };
	way = { vroom('Hacia la parte delantera', 'atmansion') };
}

light = obj {
	nam = 'encendedor';
   dsc = [[En la guantera hay un {encendedor}.]];
	exam = [[Encendedor, hermoso, caro.]];
	take = function()
		p [[Tomo un encendedor de cigarrillos.]]
		return true
	end;
	useit = function(s)
		if have(s) then
			return [[¡Funciona!]];
		end
		p [[Aún no lo he tomado.]]
	end;
	use = function(s, w)
		if w == podsobka then
			p [[Prendí el encendedor y volví a la habitación.]];
			w:enable_all();
			return
		end
		if w == acid or w == acid2 then
			gameover = true
			stop_sound(3)
			return walkin 'lightend'
		end
		if w == dihlo then
			if not w.on then
				p [[Si se quema la lata, explotará.]]
				return
			else
				if w.fire then
					return [[No hay necesidad de hacerlo.]]
				end
				w.fire = true
				w.step = 4
				return [[Con cuidado acerco el encendedor al chorro. ¡¡¡Me predí fuego!!!]];
			end
		end
		if w == ladder1 then
			p [[El encendedor da suficiente luz para explorar las oscuras escaleras superiores, pero creo que hay algo ahí...]]
			return
		end
		if w == kamin then
			p [[Podría encender la chimenea, por supuesto, pero no hay razón para perder el tiempo con eso.]]
		end
		if w == hbook or w == hobelens or w == port2 then
			p [[Me temo que el encendedor no es suficiente.]]
			return
		end
		if w == kandelabr then
			if w.light then
				p [[Ya quema.]]
			else
				p [[Encendí una vela, pero no era mucho más brillante...]];
				w.light = true
			end
			return
		end
		p [[No quiero quemarlo.]]
	end
}:disable();

wheel = obj {
	nam = 'volante';
        dsc = [[Mis manos se ponen sobre el {volante} de cuero de última moda.]];
	exam = [[El coche no es un lujo sino un medio.]];
	useit = [[Giré el volante ligeramente.]];
}

bard = obj {
	var { opened = false };
	nam = 'guantera';
	dsc = 'A mi derecha está la {guantera}.';
	exam = function(s)
		if s.opened then
			p [[Guantera abierta.]];
		else
			p [[La guantera está cerrada.]];
		end
	end;
	useit = function(s)
		s.opened = not s.opened;
		if s.opened then
			p [[Abrí la guantera.]]
			s:enable_all();
		else
			p [[Cerré la guantera.]]
			s:disable_all();
		end
	end;
	obj = { 'light' };
}
incar = room {
	nam = 'En el coche';
	pic = function(s)
		if bard.opened then
			return 'gfx/5a.png';
		else
			return 'gfx/5.png';
		end
	end;
	entered = [[Me metí en el interior del coche.]];
	left = [[Salí de nuevo a la lluvia.]];
	dsc = [[Era acogedor. La lluvia había dejado de verterse por mi cuello. Cuando sentí debajo un asiento de cuero suave, me ví como en un sueño.]];
	obj = { 'wheel', 'bard' };
	way = { vroom('Salir', 'sside') };
}

key1 = obj {
	nam = 'llave';
	dsc = function(s)
		if not taken 'flash' then
		   p [[Incluso está la {llave} colgando de unos ganchos en la parte de atrás.]]
		else
		   p [[{llave} colgando en un gancho en el cuarto de atrás.]];
		end
	end;
	exam = [[Llave de hierro de gran tamaño.]];
	useit = function(s)
		if have(s) then
			p [[Giré la llave en las manos.]]

		else
			p [[Primero hay que recogerla.]]
		end
	end;
	take = takeit [[He quitado la llave del gancho.]];
	use = function(s, w)
		if w == kotel0 then
			if w.opened then
				return [[Abrir.]]
			end
			p [[Puse la llave en una cerradura algo oxidada. ¡¡¡Funcionó!!! Сon cierta dificultad abrí al puerta.]];
			w.opened = true
			path 'Al sótano':enable()
			remove(s, me())
			return
		end
		return [[No sirve para eso.]]
	end
}:disable();

flash = obj {
	nam = 'linterna';
	var { bat = false; gun = false; on = false; };
	dsc = 'En el estante, en la parte de atrás encontré una {linterna}.';
	take = function(s)
		p [[Tomé la linterna.]]
		return true
	end;
	exam = function(s)
		if s.on then
			p [[Linterna con pilas incluidas.]]
		else
			p [[Linterna electrica.]]
		end
		if s.gun then
			p [[Está sujeta a la escopeta con cinta aislante.]]
		end
	end;
	life = function(s)
		if player_moved() and not here().dark and not s.gun then
			p [[Apagué la linterna.]]
			lifeoff(s)
			s.on = false
		end
	end;
	useit = function(s)
		if not taken(s) then
			return "Primero necesita tomarlo."
		end
		if not s.bat then
			return [[Traté de encender la linterna, pero las pilas no estaban incluidas.]];
		end
		if here().dark then
			return "Si apago la linterna, me quedaré en la oscuridad."
		end
		s.on = not s.on
		if s.on then 
			lifeon(s)
			p [[Encendí la linterna.]]
		else
			lifeoff(s);
			p [[Apagué la linterna.]]
		end
	end;
	use = function(s, w)
		if s.gun then
			p [[Linterna sujeta al rifle con cinta adhesiva.]]
		end
		if w == shotgun then
			if not taken(w) then
				return "Primero tiene que tomarlo."
			end
			if s.gun then
				return [[La linterna está sujeta al rifle.]]
			end
			if not have (isol) then
				return [[¿Añadir la linterna al rifle? Pero ¿cómo?]]
			end
			w.flash = true
			s.gun = true;
			move(s, shotgun, me())
			return [[Tuve una idea, Sujeté firmemente la linterna a los cañones con cinta adhesiva y la encendí. ¡¡¡Ahora era fácil hacer puntería!!!]];
		end
		if not s.bat then return "Linterna apagada." end
		s.on = true
		lifeon(s)
		if w == ladder1 then
			if not slug2:dead() then
				p [[Alumbré con la linterna el escalón superior. No me había engañado. Había algo en la parte superior de la escalera.]]
				slug2:enable()
			else
				p [[Parece que no hay nada.]]
			end
			return
		end
		if w == kamin then
			p [[Examiné cuidadosamente la chimenea con la linterna y descubrí que una de las piedras sobresalía un poco hacia adelante.]]
			pushstone:enable()
			return
		end
		return [[Encendí la linterna.]]
	end
}:disable();

shelf1 = obj {
	nam = 'puerta';
	var { opened  = false };
	door_type = true;
	dsc = function(s)
		if s.opened then
			p 'En {puerta}';
		else
		   p 'Bajo las escaleras hay una pequeña {puerta}.';
		end
	end;
	exam = 'Puerta del pequeño cuarto trasero.';
	useit = function(s)
		s.opened = not s.opened;
		if s.opened then
			s:enable_all()
			p [[Abrí la puerta.]]
		else
			s:disable_all()
			p [[Cerré la puerta.]]
		end
	end;
	obj = { 'podsobka' };
}:disable();

podsobka = obj {
	nam = 'despensa';
        dsc = ': abrir {despensa}.';
	exam = [[Está oscuro, no puedo ver nada.]];
	useit = [[Está demasiado estrecho y oscuro para subir hasta allí.]];
	obj = { 'flash', 'key1' };
}:disable();

function slug(v)
	v.nam = 'babosa';
	v.dscalive = v.dsc;
	if not v.name then
		v.name = 'Babosa';
	end
	v._seen = false
	v._dist = v.dist;
	if not v.delayed then
		v.delayed = false
	end
	v._trigger = v.delayed 
	v.dsc = function(s)
		if not v._dead then
			return call(s, 'dscalive');
		else
			return call(s, 'dscdead');
		end
	end
	v.dead = function(s)
		return s._dead;
	end
	v.kill = function(s)
		s._dead = true
		add_sound 'snd/squash.ogg'
		lifeoff(s)
	end
	v.exam = function(s)
		if s._dead then
			p [[Esta cosa es como una sanguijuela gigante o una babosa -- Está muerta.]]
		else
			s._seen = true
			if not live(s) then
				p [[¡¡¡Esa cosa es como una sanguijuela grande o una babosa verde!!!]]
				return
			end
			if s._dist >= 3 then
				p [[Una pequeña figura oscura. ¡¡¡Rápidamente se movió a mi lado!!!]]
			elseif s._dist >= 2 then
				p [[¡¡¡Esto parece una sanguijuela o una babosa!!! ¡¡¡Es capaz de saltar y queda poco para que llegué hasta mí!!!]]
			elseif s._dist >= 1 then
				p [[¡¡¡Esta cosa es como una sanguijuela o una alucinación!!! ¡¡¡Está muy cerca!!! ¡¡¡Y es verde!!!]]
			else
				p [[¡Es una babosa! ¡¡¡Una babosa verde gigante!!!]]
			end
		end
	end
	v.useit = [[¡¡¡Es mejor permanecer lejos de ella!!! Eso es todo.]];
	v.slug_type = true;
	v.take = [[No es necesario que la toque con las manos...]];
	v._dead = false
	v.life = function(s)
		if s._trigger then
			s._trigger = false
			return
		end

		if s._dist >=3 then
			p (s.name, [[ ha dado un salto hacia mí.]])
		else
			if s._dist ~= s.dist then
				p (s.name, [[ dió otro salto en mi dirección.]])
			else
				p (s.name, [[ dió otro salto en mi dirección.]])
			end
		end
		if s._dist == 0 then
			lifeoff(s)
			gameover = true
			slugend.adsc = s.adsc
			stop_sound(3)
			walkin 'slugend'
			return
		end
		s._dist = s._dist - 1
	end
	return obj(v)
end


slug2 = slug {
	dist = 3;
	delayed = true;
        dsc = [[¡¡¡En la parte superior de la escalera veo {cosas}!!!]];
        dscdead = [[En el suelo bajo las escaleras hay el cuerpo de una {babosa} muerta.]]
}


ladder1 = obj {
	nam = 'escalera';
	life = function(s)
		if rnd(100) > 50 then
			if seen(slug2) and not slug2:dead() then
				p [[La babosa se arrastra de un lugar a otro en el último escalón.]];
			else
				p [[Creo que de lo alto de las escaleras llegó un susurro silencioso...]]
			end
		end
	end;
	dsc = [[En el centro de la sala hay una {escalera}, que conduce al segundo piso.]];
	exam = function(s)
		p [[Elegante escalera que conduce al segundo piso, envuelto en oscuridad.]];
		if shelf1:disabled() then
			p [[Bajo las escaleras noté una pequeña puerta.]]
			shelf1:enable();
		end
	end;
	useit = function(s)
		if not slug2:dead() then
			lifeoff(s)
			p [[Empecé a subir las escaleras, cuando algo viscoso y frío me golpeó en la cabeza.]]
			gameover = true
			stop_sound(3)
			walkin 'slugend'
			return
		end
		walk(floor2) 
	end;
	obj = {'shelf1', slug2:disable() };
}

global { tree_attack = false; tree_dead = false; };
vetka = obj {
	nam = 'ramas';
	var { seen = false; step = 1 };
	dsc = function(s)
		if s.seen then
		   p [[¡¡El árbol de {ramas} retorcidas me arrastró!!]];
		else
			p [[¡¡¡{Algo} me aprieta!!!]];
		end
	end;
	exam = function(s)
		if s.seen then
			p [[¡Este árbol! ¡¡¡horrible árbol!!!]]
		else
			s.seen = true;
			p [[De repente, me di cuenta con horror que se trataba de uno de los árboles, ¡¡¡se me echa encima con sus viles ramas retorcidas!!!]];
		end
	end;
	life = function(s)
		if s.step == 1 then
			p [[Su agarre se hizo más fuerte. Caí al suelo frío.]];
		elseif s.step == 2 then
			p [[Con horror, ¡me doy cuenta de que estoy siendo arrastrado por el suelo!]];
		elseif s.step == 3 then
			s.seen = true
			p [[¡¡¡Este árbol maldito me arrastra hacia él!!! Veo sus ramas nudosas, ¡¡llegan a mí!!]]
		else
			gameover = true
			lifeoff(s)
			lifeoff(pila)
			stop_sound(3)
			walkin 'treeend'
			return 
		end
		s.step = s.step + 1
	end;
}

restart = obj {
	menu_type = true;
	nam = 'restart';
	dsc = [[{Volver a intentarlo}]];
	act = code [[ restore_snapshot(); ]];
}

acidend = room {
	nam = 'Final';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[No calculé el tiempo y mis pies se hundieron en el ácido. Casi de inmediato, sentí un dolor agudo en las plantas de los pies y perdí el conocimiento. La maldita baba me mató.]];
	obj = { restart };
}

dogend = room {
	nam = 'Final';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[¡¡¡El maldito perro me atacó!!!]];
	obj = { restart };
}

dogend2 = room {
	nam = 'Final';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[La puerta se rompió con una explosión y el maldito perro entró en el inodoro. No tuve oportunidad de hacer nada.]];
	obj = { restart };
}


lightend = room {
	nam = 'Final';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[Traté de prender fuego al estiercol verde con el encendedor. Y lo conseguí... Las llamas me envolvieron. ¡¡¡Maldito ácido!!!]];
	obj = { restart };
}

treeend = room {
	nam = 'Final';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[EL maldito árbol me ha matado.]];
	obj = { restart };
}

spiderend = room {
	nam = 'Final';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[Subí las escaleras estrechas y empujé la puerta. Se abrió con un ruido y golpeó el piso tipo loft. Empecé a subir a la buhardilla, cuando algo peludo me derribó. Era una araña. Su peludo cuerpo jengibre era del tamaño de una pelota de baloncesto. Empecé a ahogarme...]];
	obj = { restart };
}

spiderend2 = room {
	nam = 'Final';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[Lancé el desatascador a un metro de distancia. La araña estaba en el suelo, y luego se lanzó sobre mí. Empecé a ahogarme...]];
	obj = { restart };
}

spiderend3 = room {
	nam = 'Final';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[La maldita araña me mató.]];
	obj = { restart };
}

slugend = room {
	nam = 'Final';
	pic = 'gfx/34.png';
	fading = true;
	hideinv = true;
	dsc = function(s)
		if s.adsc then
			p(s.adsc)
		else
			p[[¡¡¡Estas criaturas desagradables acabaron conmigo!!!]];
		end
	end;
	obj = { restart };
}

vetkid = obj {
	nam = 'ramas';
        dsc = [[Bajo los pies ruedan las {ramas} cortadas.]];
	exam = [[¡¡¡Desagradables tentáculos pegajosos!!!]];
	take = [[¡No! ¡No voy a tocarlo!]];
	useit = [[No voy a utilizar este material.]];
}

dihlo = obj {
	nam = 'diclorvos';
	disp = function(s)
		if s.fire then
			p [[lanzallamas]]
		else
			p [[diclorvos]]
		end
	end;
	var { fire = false; on = false; step = 1; fuel = 7 };
	dsc = [[En un estante hay una lata de {diclorvos}.]];
	exam = function(s)
		p [[Lata de aerosol con diclorvos, un insecticida.]]
		if s.on then
			if s.fire then
				p [[¡Desde el recipiente sale un río de fuego!]];
			else
				p [[¡Brota de un contenedor!]];
			end
		end
	end;
	take = takeit [[Cojo una lata de diclorvos.]];
	life = function(s)
		local k,v
		for k,v in ipairs(objs()) do
			if v.slug_type and not v:dead() then
				if s.on then
					s.fuel = s.fuel - 1
					if s.fuel == 0 then
						p [[La llama del contenedor se apagó. ¿Diclorvos acabado?]]
						s.on = false
						s.fire = false
						lifeoff(s)
						return true
					end
				end
				return
			end
		end
		s.step = s.step - 1;
		if s.step == 0 then
			p [[Quito el dedo del tapón del bote.]]
			if s.fire then
				p [[La llama se apaga.]]
			end
			lifeoff(s)
			s.fire = false
			s.on = false
		else
			if not s.fire then
				p [[Brota de un contenedor.]]
			end
		end
	end;
	use = function(s, w)
		if w.slug_type then
			if w:dead() then
				return "Ya está muerto."
			end
			if not s.on then
				return "¿Pegarle con un frasco?"
			end
			if not s.fire then
				return "Me reí, diclorvos..."
			end
			if w == slug1 then
				w:kill()
				add_sound 'snd/flame.ogg'
				return "Envié un chorro de fuego al interior del refrigerador. La criatura se destruyó instantáneamente y cayó con un ruido sordo en la parte inferior de la nevera."
			end
			if w._dist > 0 then
				p [[Demasiado lejos...]]
				return
			end
			w._dist = 3
			add_sound 'snd/flame.ogg'
			p [[Envié un chorro de fuego a la babosa, pero saltó sobre mí de nuevo.]]
			return
		end
		if s.fire then
			return "¿Lanzallamas?"
		end
		p [[¿Diclorvós?]]
	end;
	useit = function(s)
		if have(s) then
			if s.on then
				s.step = 1
				s:life()
				return
			end
			if s.fuel == 0 then
				p [[He hecho clic en el botón, pero no pasó nada. ¿Diclorvos acabado?]]
				p [[Decidí arrojar la lata, ahora inutil.]]
				remove(s, me())
				return
			end
			lifeon(s);
			p [[Presiono ligeramente el botón, con un silbido de globo el chorro de diclorvos comenzó a salir.]];
			s.on = true
			s.step = 2;
		else
			p [[Lo puedo llevar conmigo.]]
		end
	end;
}

windows = function(dsc, exam, useit)
	local v = obj {
		nam = 'ventanas';
		dsc = dsc;
		exam = exam;
		useit = useit;
		window_type = true;
	}
	return v
end

treeroom = room {
	nam = 'Invernadero';
	pic = function(s)
		if tree_dead then
			return 'gfx/7a.png'
		else
			return 'gfx/7.png'
		end
	end;
	entered = function(s)
		if not tree_dead then
			make_snapshot()
		end
		if not visited() then
			p [[Con mucho cuidado abrí la puerta y entré en una habitación grande. Miré un rato a mi alrededor. Había un montón de plantas. Parece que estoy en un invernadero.]]
		end
	end;
	exit = function(s)
	if seen(vetka) then
			p [[¡¡¡No puedo salir!!!]]
			return false
		end
	end;
	dsc = [[Invernadero clasificado de la mansión, cuarto con piso de tierra.]];
	obj = { vetka:disable(),
			vetkid:disable();
			obj {
			nam = 'plantas';
			exam = function(s)
				if tree_dead then
					p [[¡Ese condenado árbol no volverá a interferir!]];
				else
				        p [[Plantas extrañas. La mayoría de ellos árboles -- de aspecto extraño. Las ramas son gruesas, nudosas y están muy entrelazados... Parecen estar vigilándome... ]];
				end
			end;
			take = [[Las flores marchitas del arriate son mejores que esas ramas nudosas...]];
			dsc = [[Las {plantas} ocupan toda la superficie del invernadero. ]];
			useit = function(s)
				if seen 'vetka' then
					p [[¡¡¡El árbol me sujeta!!!]]
				else
					if tree_dead then
						return [[¿Tomar esa criatura maldita?]]
					end
					if tree_attack then
						return [[¡Es mejor que me mantenga alejado de ellos!]]
					end
					vetka.seen = true
					vetka.step = 2
					vetka:enable()
					lifeon(vetka);
					tree_attack = true
					p [[Me acerqué a las plantas... De repente, ¡¡¡uno de los árboles estiró sus ramas nudosas hacia mí!!!]]
					p [[¡¡¡En un momento se me había enrrollado por la cintura y la apretó dominándome!!!]];
				end
			end
		},
		obj  {
			nam = 'sistema de riego';
		        dsc = [[Por encima de las plantas está el {sistema} de riego.]];
			exam = [[El agua se canaliza desde la parte superior y se pulveriza a través de pequeños agujeros.]];
			useit = function(s)
				if seen(vetka) then
					p [[ahora no estoy para estudiar el sistema de riego.]];
					return
				end
				p [[En algún lugar debe de haber grúas. No las encuentro...]];
			end;
		};
		obj {
			nam = 'estantería';
			exam = [[Creo que puede haber accesorios de jardín en los estantes.]];
			take = [[No necesito estantes.]];
			dsc = [[Contra la pared del fondo del invernadero, que apenas podía ver, hay una {estantería}.]];
			useit = function(s) 
				if tree_dead then
					p [[Me acerqué a los estantes y los examiné.]]
					dihlo:enable()
					return
				end
				if seen(vetka) then
					p [[¡No estoy en condiciones de hacerlo!]]
					return
				end
				lifeon(vetka);
				vetka.step = 1;
				vetka.seen = tree_attack
				local w = rnd(2);
				if w == 1 then
					w = 'izquierda';
				else
					w = 'derecha';
				end
				local a = rnd(4);
				if a == 1 then
					a = 'hizo un movimiento circular y me lastimó la pierna izquierda';
				elseif a == 2 then
					a = 'hizo un movimiento circular y me lastimó la pierna derecha';
				elseif a == 3 then
					a = 'me agarró por las piernas';
				else
					a = 'se me enroscó alrededor de la cintura';
				end	
				if tree_attack then
					p ([[Empecé a pasar sorteando por encima de la planta ]]..w..', cuando ¡¡¡otro tentáculo '..a..'!!!')
				else
					p ([[Empecé a pasar sorteando por encima de la planta ]]..w..', cuando ¡¡¡algo '..a..'!!!')

				end
				tree_attack = true
				vetka:enable();
			end;
			obj = { dihlo:disable() };
		};
		windows([[Habitación con poca luz que entra desde grandes {ventanas}.]],[[Por la tarde, cuando el sol se va, no puede verse hermoso...]],[[Hay una rejilla exterior en las ventanas.]]);
	 };

	way = { vroom('A la sala', 'inmansion') };
}

doors1 = obj {
	nam = 'Puerta de la derecha';
	door_type = true;
   dsc = 'A derecha e izquierda de las escaleras hay tres {puertas}.';
	exam = function(s)
		p [[Examiné todas las puertas. Dos de ellas están al lado derecho -- otra, a izquierda.]];
		d1:enable();
		d2:enable();
		d3:enable();
	end;
	useit = [[Las puertas no están cerradas.]];
}

corr1 = obj {
	nam = 'pasillo';
   dsc = [[Un estrecho {pasillo} conduce a la izquierda.]];
	exam = function(s)
		p [[El pasillo es oscuro, pero se puede pasar.]];
		path('Al pasillo'):enable();
	end;
	useit = code [[ return self:exam() ]];
}

clocktime = obj {
	nam = '10:45';
	exam = [[No sé porqué, pero me recuerda que el tiempo corre.]];
	useit = [[¿Cómo se puede utilizar?]];
	take = [[Está en mi mente.]];
	nouse = [[Parado a las 10:45, pensé... ¿10:45? 10:45... hum...]];
	use = function(s, w)
		if w == lclock then
			if w.set then return [[He ajustado las manecillas del reloj a las 10:45.]]; end
			w.set = true;
			remove(s, me())
			return [[Puedo ajustar el reloj a las 10:45.]];
		end
	end
}

lupa = obj {
	nam = 'lupa';
   dsc = [[En la parte inferior de las tablas hay una {lupa}.]];
	exam = [[Lupa con un mango grande.]];
	useit = function(s)
		if disabled(brother) then
			p [[A Andrés le gustaba quemar las cartas de papel con la lupa... ¿¿¿gustaba??? Todavía tenía que buscar a mi hermano más joven, le prometí a mi padre que me haría cargo de él.]];
		else
			p [[Se la daré a Andrés cuando se acabe...]]
		end
	end;
	take = takeit [[Puse la lupa en el bolsillo.]];
	nouse = [[Decidí usar la lupa, pero no encontré nada.]];
	use = function(s, w)
		if w == kamin then
			p [[Examinó cuidadosamente la chimenea y encontró que una de las piedras sobresalía algo hacia adelante de la mampostería.]]
			pushstone:enable()
			return
		end
		if w == hclock then
			p [[Inscripción grabada en la tapa: ERDIENST UM DEN STAAT. Гм...]];
		elseif w == foto and not taken 'clocktime' then
			p [[He examinado cuidadosamente la foto con la lupa. ¡¡¡Incluso se puede distinguir el reloj que le da a Hitler el hombre de negro!!!]];
			take 'clocktime'
		end
	end
}

tumb1 = obj {
	nam = 'mesilla';
        dsc = 'Junto a la cama hay una {mesilla} de noche.';
	useit = function(s)
		if not disabled(lupa) or here() == room1 then
			p [[He examinado cuidadosamente los cajones y no encontré nada de interés.]];
		else
			p [[Miré en los cajones. Un montón de periódicos viejos. Sobre uno de los periódicos hay una lupa.]];
			lupa:enable()
		end
	end;
	exam = [[Mesa lateral sencilla de madera.]];
}

bed1 = obj {
	nam = 'cama';
        dsc = 'La {cama} está junto a la pared.';
	exam = [[Hecha cuidadosamente.]];
	useit = [[No hay tiempo para dormir...]];
}

room1 = room {
	pic = 'gfx/11.png',
	nam = 'Habitación 1';
	dsc = [[Habitación púlcramente arreglada. Muy pequeña.]];
	obj =  { 
		bed1,
		tumb1,
	   windows([[La habitación tiene una sola {ventana}.]], [[Las gotas de lluvia corren por el cristal.]], [[Reja de ventana.]] ) 
	};
	way = { vroom('Salida', 'corr') };
}

room2 = room {
	nam = 'Habitación 2';
	pic = 'gfx/12.png';
	dsc = [[Una habitación grande, con el techo blanco y las paredes verde claro.]];
	obj =  { 
		bed1, 
		tumb1,
		lupa:disable(),
		obj {
			nam = 'armario';
		        dsc = [[Hay un {armario} ropero.]];
			useit = [[Abría la puerta y miré hacia adentro. Esta ropa no me sienta bien.]];
			exam = [[Mueble fiable. Puede resistir durante décadas.]];
		};
		windows([[La pálida luz penetra en la habitación a través de dos {ventana}s en la pared del este.]], [[Gotas de lluvia...]], [[Rejas en las ventanas.]] ) 
	};
	way = { vroom('Salida', 'corr') };
}

corr = room {
	nam = 'corredor';
	pic = 'gfx/10.png';
	dsc = [[En el pasillo oscuro, me siento incómodo.]];
	obj = { 
		obj {
			door_type = true;
			nam = 'Puerta 1';
		   dsc = [[En la pared derecha del pasillo, hay dos puertas. Creo que esta es la puerta al servicio de limpieza de las habitaciones. La {primera puerta}]];
			exam = [[Puerta de madera.]];
			useit = function(s)
				p [[Pruebo el pomo, la puerta no esta cerrada con llave.]];
				path 'Habitación 1':enable();

			end
		},
		obj {
			door_type = true;
			nam = 'Puerta 2';
			dsc = [[y la {segunda}.]];
			exam = [[Puerta de madera.]];
			useit = function(s)
				p [[Pruebo el pomo, la puerta no esta cerrada con llave.]];
				path 'Habitación 2':enable();
			end
		}
	};
	way = { vroom('A la sala', 'inmansion'), 
			vroom('Habitación 1', 'room1'):disable(), 
			vroom('Habitación 2', 'room2'):disable() };
}

switch1 = obj {
	nam = 'interruptor';
   dsc = 'En la puerta principal veo un {interruptor}.';
	exam = [[Interruptor general.]];
	useit = [[He hecho clic en el interruptor, pero la luz no se enciende. Parece que la casa no tiene energía eléctrica.]];
}

function wroom_enter(self, ...)
	return stead.walk(call(self, 'where'));
end

function wroom(a, b, c)
	local v = room { vroom_type = true, nam = a, where = c, enter = wroom_enter };
	v.oldenter = v.enter;
	v.newname = b;
	v.oldname = a;
	v._toggle = false
	v.nam = function(s)
		if s._toggle then
			return call(s, 'newname')
		else
			return call(s, 'oldname');
		end
	end
	v.enter = function(s, ...)
		local r,v =  v:oldenter(...)
		if v ~= false then
			s._toggle = true
		end
		return r, v
	end
	return v
end

d1 = wroom('Puerta 1', 'La cocina', 'kitchen'):disable();
d2 = wroom('Puerta 2', 'El invernadero', 'treeroom'):disable();
d3 = wroom('Puerta 3', 'Sala de la chimenea', 'lroom'):disable();

inmansion = room {
	nam = 'Recibidor';
	pic = 'gfx/6.png';
	entered = function(s)
		if not visited() then
			p [[Pisando los fragmentos de la puerta, entré en la mansión al pasillo oscuro. Mientras mis ojos se acostumbraron a la oscuridad, me vino una idea clara, ya sea que mi hermano no está aquí o no, parece una casa tan vacía... Sin embargo, yo sentía que mi hermano está aquí en alguna parte ...]]
		end
		if not slug2:dead() and not live(slug1) then
			make_snapshot()
			lifeon(ladder1);
		elseif not slug3:dead() and not live(slug1) then
			make_snapshot()
		end
	end;
	left = code [[ lifeoff(ladder1) ]];
	dsc = [[La oscuridad y el silencio se reunen conmigo en el espacio de la sala.]];
	way = { vroom('Afuera', 'atmansion'), 
			vroom('Al pasillo', corr):disable(), d1, d2, d3 };
	obj = { 'ladder1', 'corr1', 'doors1', 'switch1' };
}

slug1 = slug {
	dist = 0;
	delayed = true;
   dsc = [[¡¡¡{Algo} se arrastra en la nevera!!!]];
   dscdead = [[En la parte inferior de la nevera hay {restos carbonizados}.]]
}

batt = obj {
	nam = 'pilas';
   dsc = [[En uno de los estantes de la puerta del refrigerador hay {pilas}.]];

	exam = function(s)
		if have(s) then
			p [[Baterías "D".]]
		else
			p [[Hum... Dicen que las pilas deben de ser refrigeradas, espero que no estén agotadas.]];
		end
	end;
	take = takeit [[tomé las pilas.]];
	useit = [[Hum. ¿Como puedo usarlas?]];
	use = function(s, w)
		if w == flash then
			w.bat = true
			p [[Puse las pilas en la linterna. ¡¡¡Encajaron!!!]]
			inv():del(s)
			return
		end
		p [[Las pilas no ayudarán.]]
	end
}
refreg = obj {
	nam = 'refrigerador';
   dsc = [[En el otro extremo de la cocina está el {refrigerador} blanco.]];
	exam = function(s)
		if slug1:dead() then
			p [[En un refrigerador abierto hay una babosa muerta.]];
			if disabled(batt) then
				p [[Al mirar dentro, me di cuenta de que había pilas.]]
				batt:enable()
			end
		else
			p [[Hum.. Refrigerador con la puerta entreabierta...]];
		end
	end;
	useit = function(s)
		if not slug1:dead() then
			if live(slug1) then
				p [[Iba a cerrar la puerta rápidamente...]]
				return
			end
			slug1:enable()
			lifeon(slug1)
			lifeoff(s)
			p [[Miró con cautela en la nevera y se estremeció. En el refrigerador vacío, tendido en el estante del medio, ¡¡¡hay una criatura verde!!!]]
			return
		end
		p [[Examiné el interior de la nevera.]];
		batt:enable();
	end;
	life = function(s)
		if not seen(slug1) and rnd(100) > 50 then
			p [[Extrañamente, me parece oir un ruido suave, procedente de la nevera...]];
		end
	end;
	obj = { slug1:disable(), batt:disable() };
}

kitchen = room {
	nam = 'Cocina';
	pic = 'gfx/9.png',
	entered = function(s)
		if not slug1:dead() then
			make_snapshot()
		end
		if not slug1:dead() then
			lifeon(refreg);
		end
		if not visited() then
			p [[Con mucho cuidado, abrió la puerta y entró en la habitación. Resultó que estaba en la cocina. ]];
		end
	end;
	left = code [[ lifeoff(refreg) ]];
	dsc = [[La habitación de la cocina era larga y estrecha.]];
	obj = { 
		obj {
			nam = 'mesa';
		        dsc = [[Una {mesa} larga de cocinar, ocupando casi toda la pared.]];
			exam = [[Sobre la mesa hay utensilios. Lavado de vacío. ]];
			useit = [[No hay ningún alimento.]];
		};
		windows([[En las {ventanas} en el muro oeste, se apaga el crepúsculo.]], [[Parcialmente tapada.]], [[Rejas en las ventanas.]]);
		refreg;			
	};
	way = { vroom('A la Sala', 'inmansion') };
}

pushstone = obj {
	nam = 'piedra';
   dsc = [[Una de las {piedra}s de la chimenea sobresale ligeramente de la mampostería.]];
	exam = [[Igual que las demás -- еs difícil de ver.]];
	useit = function(s)
		if not lclock.set or not disabled(ladder0) then
			return [[He pulsado sobre la piedra -- no pasó nada.]];
    		end
		ladder0:enable();
		p [[He hecho clic en la piedra. Casi en el mismo momento el hogar se apartó hacia un lado y se abrió un nicho.]];
	end;
}

ladder0 = obj {
	nam = 'escalera';
   dsc = [[Sobre la chimenea, en un nicho oscuro, se abre una estrecha {escalera}, que desciende.]];
	exam = [[¡Una escalera conduce a la planta baja!]];
	useit = function(s)
		if not flash.on then	
			flash.on = true
			lifeon(flash)
			p [[En el nicho estaba bastante oscuro, así que encendí la linterna.]];
		end
		p [[Con cuidado empecé a bajar.]];
		walk 'lab';
	end
}

kamin = obj {
	nam = 'chimenea';
        dsc = [[En la pared este se asienta la {chimenea}.]];
	exam = [[La chimenea parece monumental en la noche]];
	obj = { shotgun, pushstone:disable(), ladder0:disable() };
}

ltable = obj {
	nam = 'mesa';
	dsc = [[Una {mesa} ocupa el centro de la habitación.]];
	exam = [[Mesa limpia y preparada con un mantel blanco.]];
	useit = [[Miré bajo la mesa -- vacío.]];
}

global { on_chair = false; }

lchair = obj {
	nam = 'silla';
	var { trig = false };
	dsc = [[Una {silla} se encuentra cerca de la chimenea.]];
	exam = [[Es igual que el resto.]];
	take = [[Esta silla ya no es necesaria.]];
	use = function(s, w)
		if w == kamin then
			p [[Puse la silla cerca de la chimenea.]]
			drop(s, lchairs);
			return
		end
		p [[¿Apretar una silla? No va a ayudar.]];
	end;
	life = function(s)
		if not s.trig then	s.trig = true return end
		p [[Me bajé de la silla.]]
		lifeoff(s);
		on_chair = false
		return true
	end;
	useit = function(s)
		if on_chair then
			s.trig = false
			return "Ya está en la silla."
		end
		s.trig = false
		if have(s) then
			p [[Tengo una silla en la mano.]];
			return
		end
		on_chair = true;
		p [[Me subí a una silla.]]
		lifeon(s);
	end
}

lchairs = obj {
	nam = 'sillas';
   dsc = [[Alrededor de la mesa hay {sillas}.]];
	exam = [[Que hermosas tallas. ¿Tuercas?]];
	take = function(s)
		if have(lchair) or seen(lchair) then
			return [[Yo no tenía sillas.]]
		end
		p [[Tomé una silla.]]
		take(lchair)
	end;
	useit = [[No hay tiempo para sentarse.]];
}

lclock = obj {
	nam = 'reloj';
	var { set = false };
	dsc = [[En la esquina hay un gran {reloj} de pared.]];
	exam = function(s)
		if s.set then
			return [[Las manecillas indican las 10:45.]];
		end
		p [[El relog está parado. Las manecillas se detuvieron a las 12:17.]];
	end;
	useit = [[Me pregunto ¿como hacerlo funcionar?]];
	take = [[Demasiado masivo.]];
		
}

notes = obj {
	nam = 'partituras';
        dsc = 'Son {partituras} de piano.';
	take = takeit [[Tomas las partituras.]];
	exam = function(s)
		if have(s) then
		   p [[Hum, notas en alemán: SONATE FÜR EINE DAS ALBUM FRAU VON Mathilde Wesendonck. WWV 85 (1853). Nombre escrito en la parte superior del compositor: "Richard Wagner". Mhh, ¿Wagner?]];
		else
			p [[Partituras ya examinadas.]]
		end
	end;
	useit = function(s)
		p [[No sé tocar el piano.]]
	end
}

piano = obj {
	nam = 'piano';
        dsc = 'Contra la pared del fondo hay un {piano} negro.';
	exam = function(s)
		if disabled(notes) then
			notes:enable();
			p [[Me agaché sobre las partituras del piano.]];
		else
			p [[El piano negro está en una habitación con poca luz... Las teclas brillan blancas como dientes.]];
		end	
	end;
	useit = [[Acaricié las teclas blancas...]];
	obj = { notes:disable() };
}

lroom = room {
	nam = 'Chimenea';
	pic = function(s)
		if not disabled(ladder0) then
			return 'gfx/8b.png'
		elseif taken 'shotgun' then
			return 'gfx/8a.png'
		end
		return 'gfx/8.png'
	end;
	left = function(s)
		if have(lchair) then
			p [[Al salir de la habitación, dejé la silla]];
			inv():del(lchair);
		end
	end;
	entered = function(s)
		if not visited() then
			p [[Con mucho cuidado abrió la puerta de doble ancho y entró en la espaciosa sala. ]];
		end
	end;
	dsc = [[El cuarto de la gran chimenea está vacío y silencioso. Las rejas de seguridad en la planta arrojan sombras extrañas]];
	obj = { 
		kamin,
		ltable,
		lchairs,
		lclock,
		piano,
	        windows("En la pared oeste hay {ventanas}.", "El verano pronto terminará...", [[Rejas en las ventanas.]]);
	};
	way = { vroom('A la sala', 'inmansion') };
}

isol = obj {
	nam = 'cinta aislante';
	dsc = function(s)
		if kotelshelf.broken then
		   p [[ En el suelo, junto a la placa, hay rollos de {cinta adhesiva}.]];
		else
		   p [[ En el estante inferior hay {cinta adhesiva}.]];
		end
	end;
	use = function(s, w)
		if w == shotgun then
			return [[¿No fijé nada al rifle?]]
		end
		if w == kiy then
			return [[¿No fijé nada a la señal?]]
		end
		if w == vantuz then
			return [[¿No fijé nada al desatascador?]]
		end
		return [[No hay necesidad de aislarlo.]]
	end;
	exam = [[ ¡Un rollo grande de cinta aislante de color negro! ]];	
	useit = [[ Me gusta arrancar un pedazo de cinta adhesiva, y luego pegarlo en el rollo de nuevo. ]];
	take = takeit [[ Tomé la cinta. ]];
}

kotelshelf = obj {
	var { broken = false };
	nam = 'estante';
	dsc = function(s)
		if not s.broken then
		   p [[A la salida de la caldera hay un {estante}.]];
		else
		   p [[En el suelo, delante de la caldera, hay {tablones}.]];
		end
	end;
	exam = function(s)
		if s.broken then
			p [[Buenas tablas, gruesas y largas.]];
		else
			p [[Parece hecho en casa. De ella salen clavos doblados.]];
		end
	end;
	useit = function(s)
		if not s.broken then
			p [[Cualquier cosa, nada interesante: un banco con pintura seca, cepillo, un medidor viejo...]];
		else
			p [[¿Que necesito de estos estantes?]];
		end
	end;
	take = function(s)
		if s.broken then
			if have 'doska' then
				return [[Ya tengo una.]]
			end
			take 'doska'
			return [[Tomé un tablón.]]
		else
			p [[¿Llevar un anaquel conmigo?]];
		end
	end;
	obj = { isol };
}

doska = obj {
	nam = 'Tablón';
	exam = function(s)
		if have(s) then
			p [[Tablón largo. Espero no clavarme una astilla.]];
		else
			p [[¡¡¡El fango se lo come!!!]]
		end		
	end;
	dsc = [[En el piso del pasaje en el limo verde hay un {tablón}.]];
	useit = [[¿Qué debo hacer con el?]];
	take = [[Está en esa porquería, es mejor mantener las manos lejos.]];
	var { time = 1 };
	life = function(s)
		s.time = s.time - 1
		if s.time  == 0 or player_moved() then
			lifeoff(s)
			if here() == disel then
				p [[La pasarela finalmente se ha disuelto en el limo verde.]]
			end
			remove(s, disel);
			path('Pasarela', disel):disable()
		end
	end;
	use = function(s, w)
		if w == kotelshelf then
			p [[Tiré del tablón posterior.]]
			inv():del(s);
			return
		end
		if w == acid then
			p [[Tiré el tablón en el limo verde. Casi de inmediato el borde comenzó a virar gradualmente a un tono negro. Fascinado, en un minuto o dos, vi como este tablón se disolvió totalmente en el limo verde.]]
			inv():del(s)
			return
		end
		if w == onsklad then
			p [[Tiré la tabla en el limo verde en el pasillo. Casi de inmediato el borde comenzó a virar gradualmente a un tono negro. Pero yo tenía unos minutos para ir a través de este puente a la habitación de al lado.]]
			path('Pasarela'):enable()
			s.time = 3
			lifeon(s)
			drop(s)		
			return
		end
		p [[¿¿¿mover el tablón???]]
	end
}

kotel = room {
	nam = 'Sala de calderas';
	pic = 'gfx/13.png';
	dark = true;
	enter = function(s, f)
		if not taken (flash) or not flash.bat or not flash.on then
			p [[Entré en el sótano, pero por dentro estaba muy oscuro y tuve que salir a la calle.]]
			return false
		end
		if f == nside then
			p [[Bajé al sótano. La linterna me ayudó a navegar en la oscuridad.]]
		end
	end;
	left = function(s, to)
		if to == nside and have 'doska' then
			inv():del(doska);
			p [[Al salir de la sala de calderas, tiré el tablón.]];
		end
	end;
	dsc = [[La sala de calderas era estrecha y húmeda. Un pequeño pasillo conduce al resto del sótano.]];
	obj = { obj {
			nam = 'caldera';
		        dsc = 'Establecimiento de la {caldera}.';
			exam = [[Caldera para calentar el agua.]];
			useit = [[¿Qué hago con la caldera?]];
		},
		obj {
			nam = 'Tuberías';
		        dsc = '{Tuberías} curvas recorren las paredes.';
			exam = 'Aspecto viejo.';
			useit = [[Tamborileé con los dedos sobre las tuberías.]];
		};
		kotelshelf;		
	};
	way = { vroom('Afuera', 'nside'), vroom('seguir', 'disel') };
}

onsklad = obj {
	nam = 'pasaje';
   dsc = [[Hay dos maneras de salir fuera de la sala. Una lleva de vuelta -- A la sala de calderas. La segunda es un {pasaje} a la siguiente parte del sótano.]];
	exam = [[Pasaje oscuro en el cuarto que desemboca en el limo verde.]];
	useit = [[Tratando de pasar, he tocado con los zapatos la orilla del limo verde, que inunda parte de la planta. Surgió un olor a goma quemada y rápidamente salté hacia atrás. ¿Ácido?]];
}

acid = obj {
	nam = 'ácido';
   dsc = [[El suelo está lleno de {estiercol} verde.]];
	exam = [[Un olor repugnante, agridulce y enfermizo, golpea la nariz... Esta mierda inundó parte de la superficie del suelo, hay mucha sobre todo cerca de la bomba.]];
	useit = [[No quiero tocar eso...]];
}

disel = room {
	nam = 'Generador Diesel';
	dark = true;
	pic = function(s)
		if seen 'doska' then
			return 'gfx/14a.png'
		end
		return 'gfx/14.png'
	end;
	enter = function(s, f)
		if f  == kotel then
			p [[Con cuidado fui a la habitación de al lado.]];
		end
		make_snapshot()
	end;
	dsc = [[El sótano era más amplio que la sala de calderas.]];
	obj = { obj {
				nam = 'generador';
		                dsc = [[En la pared occidental hay un {generador} diesel.]];
				exam = [[No funciona, tal vez se haya agotado todo el combustible...]];
				useit = [[Si enciendo el generador puede volver a haber luz en la casa. Pero, ¿dónde tomo el combustible y cuánto tiempo se dedica a la puesta en marcha de esta cosa.]];
			},
			obj {
				nam = 'bomba';
	   		        dsc = [[En la parte oriental hay una {bomba} de agua.]];
				exam = [[Tienen una especie de pozo artesiano. Por supuesto no hay electricidad ni suministro de agua. Curiosamente, el piso de debajo de la bomba está completamente inundado de un limo verde. Parece que fluye más limo a lo largo de la tubería conductora.]];
				useit = [[¿Encender la bomba? ¿Pero como? El generador diesel no está funcionando.]];
			};
			onsklad,
			acid,		
	};
	way = { vroom('A sala de calderas', 'kotel'), vroom('Pasarela', 'sklad'):disable() };
}

acid2 = obj {
	nam = 'abono líquido';
	dsc = [[Una especie de {estiercol líquido} viscoso y verde goteaba en el suelo.]];
	exam = function(s)
		p [[Esta materia está inundando casi todo el suelo y desemboca en el generador diesel.]]
	end;
	useit = [[¿Nadar en ello?]];
	take = [[Supon que eres un investigador experimentado ¿¿¿Tomarías el ácido con las manos???]];
}

barrels = obj {
	nam = 'barriles';
   dsc = [[La mayor parte del local está ocupada por {barriles} de metal. Las tapas de varios de ellos habían sido arrancadas]];
	exam = [[Barriles verdes, siete u ocho piezas. Con esa cosa verde por fuera. Parece que, por alguna razón, han aumentado en volumen, reventaron y se abrió la tapa.]];
}

doska2 = obj {
	nam = 'tablón';
	var {time = 4 };
	dsc = [[Bajo mis pies, el {tablón} está casi destruido.]];
	exam = [[¡¡¡Queda muy poco tiempo!!!]];
	take = [[Estoy en ello.]];
	useit = [[He encontrado ya la manera de utilizar este tablón.]];	
	life = function(s)
		s.time = s.time - 1
		if s.time == 0 then
			lifeoff(s)
			gameover = true
			stop_sound(3)
			walkin 'acidend'
			return
		end
		p [[Sale humo del tablón. Poco a poco se ennegrece.]]
	end
}

shelfs1 = obj {
	nam = 'estantes';
   dsc = [[En las paredes a la derecha y la izquierda de la entrada instalaron {estantes} de madera.]];
	exam = function(s)
		if not taken(box1) then
		   p [[A mi derecha, al borde del estante, noté que había una pequeña caja de cartón.]];
			box1:enable();
		else
			p [[No descubrí nada de interés que esté accesible.]]
		end
	end;
	useit = function(s)
		p [[Puedo acanzar la estantería derecha.]];
	end;
	obj = { 'box1' };
}

dropshells = obj {
	nam = 'casquillos vacíos';
   dsc = [[A mis pies tendidos dos {casquillos vacíos} de escopeta.]];
	exam = [[Casquillos vacíos.]];
	take = [[No los necesito.]];
	useit = [[Son inútiles.]]
}

shells = obj {
	nam = 'munición';
	var { first = true };
	exam = [[Cartuchos para escopeta.]];
	useit = [[¿Como usarlos?]];
	use = function(s, w)
		if w == shotgun then
			if w.armed then
				return [[La escopeta está cargada.]]
			end
			w.armed = true
			add_sound 'snd/load.ogg'
			if not s.first then
				p [[Volví a cargar la escopeta.]]
				add_sound 'snd/drop.ogg'
				put(dropshells)
			else
				p [[Cargué la escopeta.]]
			end
			s.first = false
			return
		end
		if w == revol then
			return [[No es ese calibre.]]
		end
		p [[Los cartuchos no son necesarios aquí.]]
	end
}

box1 = obj {
	nam = 'caja';
   dsc = [[Sobre el estante de la derecha hay una {caja} de cartón.]];
	exam = function(s)
		if not have(s) then
			p [[Puedo alcanzar los estantes de la derecha. Hay una pequeña caja de cartón.]];
		else
			p [[¿Abierto?]]
		end
	end;	
	useit = function(s)
		if have(s) then
			p [[Abrí la caja. Guau, ¡tuve suerte! ¡¡¡había balas!!!]]
			replace(s, shells, me())
		else
			p [[¿Qué debo hacer con ella?]]
		end
	end;
	take = takeit [[Cogí una caja.]];
}:disable();

sklad = room {
	nam = 'almacén';
	pic = 'gfx/15.png';
	dark = true;
	left = function(s)
		lifeoff(doska2);
		p [[Corrí de vuelta al generador. El tablón bajo mis pies finalmente se hundió en el lodo verde.]]
	end;
	entered = function(s)
		make_snapshot()
		p [[Corrí hacia el extremo de la tabla y rápidamente miré a mi alrededor.]];
		doska2.time = 5
		lifeon(doska2);
	end;
	dsc = [[Estoy en el almacén.]];
	way = { vroom('Al generador', 'disel') };
	obj = { barrels, acid2, doska2, shelfs1, obj {
			nam = 'puerta';
		        dsc = [[En la pared opuesta hay una {puerta} de acero.]];
			exam = [[Parece bloqueada.]];
			useit = [[No entiendo...]];
		}
	 };
}

slug2dead = obj {
	nam = 'grumos';
	dsc = function(s)
		local c = 0
		if slug3:dead() then c = c + 1 end
		if slug4:dead() then c = c + 1 end
		if slug5:dead() then c = c + 1 end
		if c == 1 then
		        p [[Esparcidos en el suelo, los {restos} grumosos de una babosa.]]
		elseif c == 2 then
		        p [[Esparcidos por el suelo, los {restos} grumosos de dos babosas.]]
		else
	  	        p [[Esparcidos en el suelo, los {restos} grumosos de tres babosas.]]
		end
	end;
	take = [[De ninguna manera...]];
	exam = [[Feo espectáculo...]];
	useit = [[No veo como puede ser útil.]]
}

slug3 = slug {
	dist = 1;
	delayed = true;
	name = [[primera babosa]];
	adsc = [[La primera babosa saltó sobre mí.]];
	descs = {
	   txtem "¡Veo a la primera {babosa} prepararse para el salto final!";
	   "La primera {babosa} está a tres metros de distancia.";
	   "La primera {babosa} comenzó a moverse en mi dirección.";
	   "La primer {babosa} está muy lejos.";
	};
	dsc = function(s)
		p (s.descs[s._dist + 1])
	end;
};

slug4 = slug {
	dist = 0;
	name = [[segunda babosa]];
	delayed = true;
	adsc = [[La segunda babosa saltó sobre mí.]];
	descs = {
	   txtem "¡Veo a la segunda {babosa} prepararse para el salto final!.";
	   "¡La segunda {babosa} ya está muy cerca de mí!";
	   "La segunda {babosa} se arrastra a distancia.";
	   "La segunda {babosa} está muy lejos.";
	};
	dsc = function(s)
		p (s.descs[s._dist + 1])
	end;
};

slug5 = slug {
	dist = 2;
	delayed = true;
	name = [[Tercera babosa]];
	adsc = [[La tercera babosa saltó sobre mí.]];
	descs = {
	   txtem "¡Veo a la tercera {babosa} prepararse para el salto final!";
	   "¡La tercera {babosa} me alcanzará pronto!";
	   "La tercera {babosa} está a 6 metros de distancia.";
	   "La tercera {babosa} está muy lejos.";
	};
	dsc = function(s)
		p (s.descs[s._dist + 1])
	end;
};

cor2 = obj {
	nam = 'corredor';
	dsc = function(s)
		 p [[Desde las escaleras, subiendo desde la planta baja a la segunda planta se opone un largo {corredor}.]];
	
	local c = 0
		if not slug3:dead() then c = c + 1 end
		if not slug4:dead() then c = c + 1 end
		if not slug5:dead() then c = c + 1 end
		if c == 2 then
			p [[En el corredor quedan dos babosas.]]
		elseif c == 3 then
			p [[Tres babosas se arrastran por el suelo.]]
		end		
	end;
	exam = [[El corredor se extiende a lo largo del muro occidental.]];
	useit = [[En el suelo del corredor hay una alfombra roja.]];
}


d23 = wroom('Puerta 3', 'La biblioteca', 'library');
d21 = wroom('Puerta 1', 'La habitación de huéspedes', 'guests');
d22 = wroom('Puerta 2', 'Sala de recreo', 'happyr');



doors2 = obj {
	nam = 'puertas';
	door_type = true;
	dsc = 'A lo largo del pasillo, delante de las ventanas están las {puertas}.';
	exam = function(s)
		p [[Examiné todas las puertas. Son similares a las otras.]];
	end;
	useit = [[Las puertas no están cerradas.]];
}

ladder2n = obj {
	nam = 'escalera del norte';
        dsc = [[En el {Norte} y]];	
	exam = [[Parece que el camino está despejado...]];
	useit = function(s)
		floor3.from = 'n';
		p [[Subí las escaleras hacia el norte hasta el tercer piso.]]
		walk 'floor3'
	end
}

ladder2s = obj {
	nam = 'escalera del sur';
   dsc = [[en el extremo {Sur} de la sala están las escaleras hasta el tercer piso.]];
	exam = [[Parece que el camino está despejado...]];
	useit = function(s)
		floor3.from = 's';
		p [[Subí las escaleras hacia el sur hasta el tercer piso.]]
		walk 'floor3'
	end
}

floor2 = room {
	nam = 'Segundo piso';
	dsc = [[Estoy en el segundo piso de la mansión.]];
	pic = function(s)
		if live(slug3) or live(slug4) or live(slug5) then
			return 'gfx/16.png'
		else
			return 'gfx/17.png'
		end
	end;
	exit = function(s)
		if not slug3:dead() or not slug4:dead() or  not slug5:dead() then
			lifeoff(slug3);
			lifeoff(slug4);
			lifeoff(slug5);
			p [[Traté de salir de este lugar terrible, pero una de las criaturas me atacó...]]
			gameover = true
			stop_sound(3)
			walkin 'slugend'
			return
		end
	end;
	entered = function(s, f)
		if f == inmansion then
			p [[Con mucho cuidado subí las escaleras, encendiendo mi linterna.]]
			if not slug3:dead() then
				slug4._dist = 0
				slug3._dist = 1
				slug5._dist = 2
				lifeon(slug3)
				lifeon(slug4)
				lifeon(slug5)
				p [[Cuando superó el último peldaño, descubrió con horror que estaba rodeado por tres criaturas verdes. Una de ellos está lista para saltar..]]
			end
		else
			if not dog:dead() then
				make_snapshot()
			end
		end
	end;
	obj = { cor2, 'slug3', 'slug4', 'slug5', 
		windows([[Las {ventanas} están situadas en el lado Este.]], [[Desde las ventanas se ve un paisaje terrible.]], [[¿Saltar abajo?]]), doors2, ladder2n, ladder2s  };
	way = { vroom('Abajo', inmansion), d21, d22, d23 };
}
global { book_sw = 0 };
function book(n, sw)
	local v = obj {
		nam = 'libro';
		sw = sw;
		dsc = '{'..n..'}^';
		exam = [[Parece un libro.]];
		take = function(s)
			if s.sw then
				return [[¡Extraño! El libro se soltó de mis manos y volvió a su lugar de nuevo.]]
			end
			p [[Tomé el libro en las manos y lo devolví a su sitio de nuevo.]]
		end;
		useit = function(s)
			if s.sw then
				if book_sw == 6 then
					return [[He jugado con los libros.]]
				end
				p [[El libro estaba de alguna manera conectado a la plataforma. Sólo pude inclinarlo ligeramente hacia atrás y se volvió a colocar alineado con los otros.]]

				if s.sw == book_sw + 1 or s.sw == 1 then
					book_sw = s.sw
					if book_sw == 2 then
						p [[En este caso hizo un ligero clic.]]
					elseif book_sw == 3 then
						p [[¡Escuchó y oyó el clic de nuevo!]]
					elseif book_sw == 4 then
						p [[Una vez más, oí el sonido de un mecanismo de activación.]]
					elseif book_sw == 5 then
					   p [[¡¡¡Hizo clic una vez más confirmando mi corazonada!!!]];
					end
				else
					book_sw = 0
					p [[Sin embargo oí un golpe suave.]]
				end
				if book_sw == 6 then
					p [[Allí estaba el buen funcionamiento del mecanismo, y una estantería con libros giró sobre su eje.]];
					walk 'library'
					path 'cámara secreta':enable()
					hiddenpath:enable()
					return
				end
			else
				p [[Pasé la mano por el lomo.]];
			end
		end;
	}
	return v
end

books2n = room {
	nam = 'Libros';
	pic = 'gfx/21.png',
	dsc = [[Fui a los anaqueles y pasé la vista sobre los lomos de algunos libros. Hum... ¡¡¡sólo autores alemanes!!!]];
	enter = function(s)
		if book_sw == 6 then
			p [[¡Puedes atravesar la estantería!]]
			return false
		end
	end;
	obj = {
		book("Friedrich von Sallet");
		book("Karl Lebrecht Immermann");
		book("Erich Maria Remarque", 6),
		book("Thomas Bernhard");
		book("Karl Grünberg", 3),
		book("Philipp von Zesen");
		book("Emil Ludwig");
		book("Freiherr von Novalis", 4),
		book("Friedrich Schlegel");
		book("Wilhelm Arent", 2),
		book("Max Weber", 1),
		book("Günter Eich", 5),
	};
	way = { vroom('Alejarse', 'library') };
}


books2e = room {
	nam = 'libros';
	pic = 'gfx/21.png',
	dsc = [[Fuí a los estantes y ojeé los títulos de algunos libros.]];
	obj = {
		book('Obras completas de Marx y Engels');
		book('E.B.');
		book('Escritos de Hegel');
		book('Escritos de Schopenhauer');
		book('Obras completas de Nietzsche');
		book('Obras Completas de Lenin');
	};
	way = { vroom('Alejarse', 'library') };
}

books2s = room {
	nam = 'Libros';
	pic = 'gfx/21.png',
	dsc = [[Fui a los anaqueles y pasé la vista sobre los lomos de algunos libros.]];
	obj = {
		book('Manual de Astronomía');
		book('Manual de Química');
		book('Manual de Física');
		book('Manual de Biología');
		book('Manual de Geografía');
	};
	way = { vroom('Alejarse', 'library') };
}


shelf2n = obj {
	nam = 'Gabinete norte';
	dsc = [[{Norte}]];
	exam = function(s)
		if book_sw == 6 then
			return [[¡Una de las carcasas gira sobre su eje!]]
		end
		p [[Aquí hay dos librerías.]];
	end;
	take = [[¿tomar la estantería?]];
	useit = code [[ walk 'books2n' ]];
}

shelf2e = obj {
        nam = 'Gabinete Oriental';
   dsc = [[A lo largo de las paredes en la zona {Este},]];
	exam = [[A lo largo de la pared del Este hay cuatro librerías. Esta serie de libros para leer -- no tiene demasiado interés.]];
	useit = code [[ walk 'books2e' ]];
	take = [[¿Tomar la librería?]];
}

shelf2s = obj {
	nam = 'Gabinete Sur';
        dsc = [[y {Sur} hay grandes ]];
	exam = [[Aquí hay dos librerías.]]; 
	useit = code [[ walk 'books2s' ]];
	take = [[¿Tomar la librería?]];
}

shelfs2 = obj {
	nam = 'estanterías';
	dsc = function(s)
		p [[{estanterías}.]];
	end;
	exam = [[Estanterías de madera muy sólida, repletas de libros.]];
	useit = [[Son como armarios ¿Qué se puede hacer con ellas?]];
	take = [[Estos son demasiado grandes.]]
}

hobelens = obj {
	nam = 'tapices';
        dsc = [[Las paredes están cubiertas por {tapices} rojos y negros con esvásticas.]];
	take = [[¡No necesito esta mierda!]];
	useit = [[Revisé la pared detrás de la tapicería y no encontré nada.]];
	exam = [[¡Esvásticas negras como arañas! No me gusta este lugar.]];
}

port2 = obj {
	nam = 'retrato';
	dsc = [[Justo enfrente de la entrada en la pared cuelga un {retrato} de Hitler]];
	exam = [[Por lo tanto, el anfitrión -- fascista. Parece que la guerra no ha terminado...]];
	useit = [[No sin un estremecimiento, he comprobado el espacio tras el retrato y no encontré nada.]];
	take = [[¡No lo voy a tomar!]];
}

hbook = obj {
	nam = 'libro';
        dsc = [[Sobre la mesa hay un grueso {libro} encuadernado.]];
	take = [[Tomé el libro y lo abrí. Estaba escrito en alemán, pero a pesar de ello, rápidamente me di cuenta de que era un libro de Hitler. En las primeras páginas se indicaban los años de su vida: 1889 - 1945. Con disgusto tiré el libro.]];
	exam = [[El libro es grueso y encuadernado en cuero.]];
	useit = [[¿Que debo hacer con el?]];
}

kandelabr = obj {
	nam = 'candelabro';
	var { light = false };
	dsc = function(s)
		if s.light then
			p [[Al lado de la mesa hay un {candelabro} con velas encendidas.]]
		else
		   p [[Al lado de la mesa, un {candelabro} de araña.]]
		end
	end;
	exam = [[Queda tan solo una vela.]];
	useit = [[No sé que voy a hacer con el candelabro.]];
	take = [[Es demasiado pesado para llevarlo conmigo. Y no es algo útil, como una motosierra.]]
}

foto = obj {
	nam = 'foto';
	dsc = [[Junto al libro hay una {fotografía}.]];
	exam = function(s)
		if taken(s) then
			p [[Una foto en blanco y negro muestra a dos personas. Una de ellas es Hitler; la otra un hombre con una barba rala vestido con un traje oscuro. Hitler estrecha su mano derecha al de negro, mientras que en la izquierda sostiene un reloj de bolsillo grande.]];
		else
			p [[Una imágen pequeña en un marco.]];
		end
	end;
	useit = function(s)
		if have(s) then
			p [[Al otro lado la fecha de la foto: 11.09.1939]];
		else
			p [[La foto está sobre la mesa.]]
		end
	end;
	take = takeit [[Tomé una foto.]];
}

stolik3 = obj {
	nam = 'una mesa';
        dsc = [[En medio hay una pequeña {mesa} redonda con una sola pata.]];
	exam = function(s)
		p [[Mesa guarnecida con un paño rojo.]]
		if disabled(hbook) then
			p [[Sobre la mesa, me di cuenta de un libro y una foto pequeña.]]
			hbook:enable();
			foto:enable()
		end
	end;
	obj = { hbook:disable(); foto:disable() };
	useit = [[La mesa no ayuda. Sobre todo -- ESTA mesa.]];
}

hidden2 = room {
	nam = "Cámara secreta";
	pic = 'gfx/22.png';
	dark = true;
	enter = function(s)
		if not flash.on then
			p [[Estaba oscuro, no me atreví a entrar en la sala con la linterna apagada.]]
			return false
		end
	end;
	entered = [[No sin un estremecimiento, entré en un lugar oscuro...]];
	left = [[Volví de la habitación secreta a la biblioteca.]];
	dsc = [[Estoy en una pequeña habitación de madera.]];
	obj = { hobelens, port2, stolik3, kandelabr };
	way = { vroom('Salida', 'library') };
}

hiddenpath = obj {
	nam = 'pasaje escondido';
	dsc = [[Una de las librerías en el lado norte se giraba sobre su eje, revelando un {pasadizo} secreto.]];
	exam = [[Está oscuro, se ve como una pequeña habitación de madera.]];
	useit = [[Puedes pasar allí...]];	
}

stolik2 = obj {
        nam = 'mesa';
        dsc = [[En el centro de la habitación hay una {mesa} ovalada.]];
	exam = [[Mesa de madera.]];
	useit = [[No necesito una mesa.]]
}

chairs2 = obj {
	nam = 'sillas';
        dsc = [[Alrededor de la mesta están las {sillas} de cuero.]];
	exam = [[Las sillas están tapizadas en cuero negro. Parecen amenazadoras en la oscuridad.]];
	useit = [[No, prefiero no sentarme en esas sillas negras.]];
}

library = room {
	nam = 'Biblioteca';
	pic = function(s)
		if disabled(hiddenpath) then
			return "gfx/20.png"
		else
			return "gfx/20a.png"
		end
	end;
	entered = function(s, f)
		if not visited() then
			p [[Entré en la habitación y miré alrededor. ¡Parece que estoy en la biblioteca!]];
		end
	end;
	dsc = [[La sala ocupa el ala Sur del segundo piso.]];
	obj = { stolik2, chairs2, shelf2e, shelf2n, shelf2s, shelfs2, hiddenpath:disable(),
		windows("La luz llega a través de la {ventana} en la pared oeste de la biblioteca", "Pronto estará oscuro...", "Miré por la ventana -- el patio estaba desierto.")};
	way = { vroom('Al pasillo', floor2), vroom('cámara secreta', hidden2):disable() };
}

guests = room {
	nam = 'Habitación de huéspedes';
	pic = 'gfx/18.png';
	entered = function(s, f)
		if not visited() then
			p [[Entré en la habitación y miré a mi alrededor. Era una habitación pequeña y, a juzgar por la forma intacta en que está todo, parece la habitación de huéspedes...]];
		end
	end;
	dsc = [[Estoy en una pequeña habitación de madera.]];
	obj = {
		windows([[En una {ventana} tamborilea la lluvia.]],
			[[Hay que darse prisa, pronto comenzará a oscurecer.]],
			[[No tenía en mente hacer nada con la ventana.]]);

		obj {
			nam = 'cama';
		   dsc = [[Hay una {cama} hecha, junto a la pared, ]];
			exam = [[Hecha cuidadosamente. Creo que no han dormido en ella desde hace mucho tiempo.]];
			useit = [[Miré bajo la cama. Vacío.]];
		};

		obj {
			nam = 'mesita de noche';
		   dsc = [[y una {mesita de noche}.]];
			exam = [[Una pequeña mesa lateral de madera.]];
			useit = [[Miré en el interior de los cajones y no encontré nada de interés.]];
		};
		obj {
			nam = 'Lámpara';
		   dsc = [[En el aparador hay una {lámpara} de noche.]];
			exam = [[Es hermosa.]];
			take = [[Sin electricidad es inutil.]];
			useit = [[He hecho clic en el interruptor. No funciona. La casa no tiene luz. ]];
		};
		obj {
			nam = 'armario';
	                dsc = [[El {armario} está en la pared de enfrente.]];
			exam = [[Un armario.]];
			useit = [[El armario sólo tenía una percha dentro.]];
		}
	};
	way = { vroom('Al pasillo', floor2) };
}

kiy = obj {
	nam = 'palo de billar';
   dsc = [[sobre la mesa hay un {palo de billar}.]];
	take = takeit [[Tomé el taco de billar.]];
	exam = [[Largo y fuerte.]];
	useit = [[¿Jugar al billar? Mi padre y mi hermano me enseñaron...]];
	use = function(s, w)
		if w == vantuz then
		   p [[Uso la cinta para sujetar el desatascador al palo de billar. Ahora tengo una interesante herramienta.^ Espero, lo sé, ¿por qué lo hago.]];
			remove(s, me())
			w.kiy = true
			return
		end
		if nameof(w) == 'billar' then
			p [[Ahora no estoy de humor...]]
			return
		end
		if w == luk then
			if not dog.down then
				return [[Mientras voy hacia la escotilla me va a comer.]];
			end
			return [[Demasiado corto para alcanzar.]];
		end
		return [[¿apretar el palo? hum...]];
	end;
}

happyr = room {
	nam = 'Sala de recreo';
	pic = 'gfx/19.png';
	dsc = [[Estoy en una habitación bastante grande, decorada con tapices. ]];
	obj = {
		windows("A través de la {ventana} en la pared oeste de la habitación penetra la luz.",	"Por tanto es fácilmente visible en el espacio delante de la mansion.",	"No abrí la ventana.");
		obj {
			nam = 'gramófono';
		        dsc = [[En una de las ventanas en una pequeña mesa junto a la pared hay un {gramófono}.]];
			useit = [[Escuchar música ahora sería un escape de la realidad.]];
			exam = [[Sobre la mesa había un disco. Hum... ¿Wagner?]];
		};
		obj {
			nam = 'billar';
	   	        dsc = [[En la habitación hay una {mesa} de billar.]];
			exam = function(s)
				if disabled(kiy) then
					p [[Vi una marca sobre la mesa.]];
					kiy:enable()
					return
				end
				p [[Las bolas de billar están distribuidas al azar sobre la mesa. Parece que no llegaron a acabar esta partida.]]
			end;
			useit = [[Esta mesa es para jugar al billar.]];
			obj = { kiy:disable() };
		};
		obj {
			nam = 'narguilé';
		   dsc = [[En el otro extremo de la mesa hay un {narguile} tallado.]];
            	        exam = [[Aquí está la zona de fumadores...]];
			useit = [[¿¿¿Fumar mucho y olvidarse de todo???]];
			take = [[¿Llevarlo conmigo y luego soltar algo de humo? Extraños pensamientos...]];
		};
		obj {
			nam = 'sillas';
	                dsc = [[A lo largo de las paredes y alrededor de las tuberías del agua están las {sillas}.]];
			exam = [[De madera tallada en las patas traseras... hechas en nuestra casa en su mayoría, mi padre las reparó con Andrés el viernes pasado...]];
			take = [[No tiene sentido reordenar las sillas.]];
			useit = [[Me senté en una silla y tomé un poco de aliento.]];
		};
	};
	way = { vroom('Al pasillo', floor2) };
}


d31 = wroom('Puerta 1', 
	function() if floor3.from == 'n' or dog.down then return 'WC' end return 'Dormitorio' end, 
	function() if floor3.from == 'n' or dog.down then return 'toilet' end return 'sleeping' end);


d32 = wroom('Puerta 2', 
	function() if floor3.from == 'n' or dog.down then return 'Cuarto de baño' end return 'Estudio' end,
	function() if floor3.from == 'n' or dog.down then return 'bath' end return 'bossr' end);


d33 = wroom('Puerta 3', 
	function() if floor3.from == 'n' or dog.down then return 'Estudio' end return 'Cuarto de baño' end,
	function() if floor3.from == 'n' or dog.down then return 'bossr' end return 'bath' end);



d34 = wroom('Puerta 4', 
	function() if floor3.from == 'n' or dog.down then return 'Dormitorio' end return 'WC' end,
	function() if floor3.from == 'n' or dog.down then return 'sleeping' end return 'toilet' end);

doors3 = obj {
	nam = 'puertas';
	door_type = true;
	dsc = function(s)
		 p 'A lo largo del pasillo delante de las ventanas están las {puertas}.';
	end;
	exam = function(s)
		p [[Examiné todas las puertas. Se parecen entre sí.]];
		if door34.broken then
			p [[Una de las puertas está aserrada.]]
		end
	end;
	useit = [[Las puertas no están cerradas.]];
}

tdoor = obj {
	nam = 'puerta';
	dsc = function(s)
		if not dog:dead() then
			p [[El pestillo de esta {puerta} está echado. Cerrada.]];
			return
		end;
		p [[La {puerta} se abrió.]];
	end;
	exam = function(s)
		if not dog.down then
			p [[No creo que soporte los ataques de esa criatura infernal durante mucho rato.]];
			return
		end
		p [[En la puerta - un agujero del disparo.]];
	end;
}

toilet = room {
	nam = 'WC';
	pic = 'gfx/25.png';
	enter = function(s)
		if floor3.from == 's' and not dog:dead() then
			p [[¡¡¡Esta puerta está en el extremo opuesto del pasillo!!!]];
			return false
		end
	end;
	entered = function(s)
		if not dog:dead() then
			dog.state = 3
			p [[¡¡¡Corrí a la puerta a mi derecha y la cerré de golpe detrás de mí!!! Milagrosamente, me di cuenta de la cerradura y cerré la puerta tras de mí. Un instante después oí un resoplido.]];				
		end
	end;
	exit = function(s)
		if not dog.down then
			p [[¡No voy a entrar en las fauces de la bestia!]]
			return false
		end
	end;
	dsc = [[Estoy en el baño.]];
	obj = { tdoor,
		obj {
			nam = 'taza del inodoro';
		   dsc = [[{taza} del baño.]];
			exam = [[Blanco y monumental.]];
			useit = [[Sí, todo lo que pasó en esa casa no puede permanecer en el estómago, pero... aún no he terminado, ¿por qué vienen?...]];
		};
		obj {
			nam = 'lavabo';
  		        dsc = [[Muy cerca se encuentra el {lavabo}.]];
			exam = [[Hay jabón y un espejo.]];
			useit = [[No hay agua corriente en la casa.]];
		};
		obj {
			nam = 'ganchos';
			dsc = [[En la pared cuelgan tres {ganchos}.]];
			exam = [[Una extraña sensación de deja-vu no me deja.]];
			take = [[Firmemente asegurados.]];
			useit = [[No puedo pensar en usar estos ganchos.]];
		};
		windows([[Por encima de la taza del baño la {ventana} está abierta.]], [[A través de la ventana abierta del cuarto de baño entra una gota de lluvia.]], [[Puedo salir por la ventana, pero eso significaría la derrota.]]);
	};
	way = { vroom('Al pasillo', 'floor3') };
}

medal = obj {
	nam = 'medalla';
	exam = function(s)
		if have(s) then
			p [[Medalla redonda grande. ¡Parece que ganó la exposición canina!]];
		else
			p [[Algo redondo...]];
		end
	end;
	useit = [[¿Porqué debería?]];
	take = takeit [[Cogí un objeto extraño en el suelo.]];
	dsc = [[Al lado del monstruo hay {algo} brillante...]];
	nouse = [[Difícil de aplicar a un perro una medalla tan grande.]];
}:disable()

dog = obj {
	nam = 'perro';
	var { killed = false; down = false; state = 5; shot = 0; };
	dead = function(s)
		return s.killed
	end;
	life = function(s)
		s.state = s.state - 1
		if s.state == 4 then
			if here() == floor3 then
				p [[¡Oigo el sonido de las patas en el suelo!]];
			end
		elseif s.state == 3 then
			if here() == floor3 then
				p [[¡¡¡Los golpes de las patas enormes sacuden el piso!!!]]
			end
		elseif s.state == 2 then
			if here() == floor3 then
				gameover = true
				lifeoff(s)
				stop_sound(3)
				walkin 'dogend'
			end
			p [[El monstruo golpea la puerta cerrada.]]
		elseif s.state == 1 then
			p [[¡¡La puerta no va a permanecer en pie mucho rato!!]]
		elseif s.state == 0 then
			p [[¡¡Algo masivo se interpone en el centro de la puerta!!]]
			gameover = true
			lifeoff(s)
			stop_sound(3)
			walkin 'dogend2'
		else
			return
		end
	end;
	useit = function(s)
		if not s.down then
			return [[¡¡¡Hay que hacer algo!!!]];
		end
		return [[No quiero profundizar en esto.]]
	end;
	exam  = function(s)
		if s.killed then
			p [[Ahora esta cosa ya no es peligrosa.]]
		elseif s.down then
			p [[¡¡¡Parece un perro negro gigantesco!!! De las numerosas heridas en la alfombra gotea líquido verde...]]
		else
			if s.state == 4 then
				p [[¡Esa cosa se parece a un perro gigante!]]
			elseif s.state == 3 then
				p [[¡¡¡Un perro negro gigante!!! ¡¡Tenía los ojos inyectados en sangre!!]];
			else
				p [[¡¡¡Veo las fauces del perro gigante en el suelo goteando saliva!!!]]
			end	
			return
		end
		if disabled(medal) then
			medal:enable()
			p [[Me dí cuenta de que algo brillaba al lado del monstruo...]];

		end
	end;
	dsc = function(s)
		if s.killed then
		   return [[En la puerta del inodoro se encuentran los restos del {monstruo} negro.]]
		end
		if s.down then
		   return [[Junto a la puerta del inodoro yace un {monstruo} negro.]]
		end
		if s.state == 4 then
		   p [[¡Desde el fondo del pasillo viene un {monstruo} negro corriendo!]];
		elseif s.state == 3 then
		    p (txtem([[¡¡¡Un {perro} negro se acerca dando enormes saltos!!!]]))
		elseif s.state == 2 then
		elseif s.state == 1 then
		elseif s.state == 0 then
		else
			return
		end
	end;
	take = [[Yo prefiero los gatos.]];
}

floor3 = room {
	nam = 'Tercer piso';
	pic = function(s)
		if dog.down then
			if sleeping.broken then
				return 'gfx/26a.png'
			end
			return 'gfx/26.png'
		end
		if s.from == 'n' then
			if dog.state == 4 then
				return 'gfx/24.png'
			else
				return 'gfx/24a.png'
			end
		else
			if dog.state == 4 then
				return 'gfx/24l.png'
			else
				return 'gfx/24la.png'
			end			
		end
	end;
	var { from = 'x'; };
	entered = function(s)
		if not dog.down then
			lifeon(dog)
			if not dog.down then
				p [[De repente oí claramente el sonido de algo que se acercaba a mí]]
				if s.form == 's' then
					p [[La puerta 1 está junto a la escalinata del norte -- la puerta 4, junto a la sur.]]
				end
			end
		elseif (not spider1:dead() or not spider:dead()) and dog:dead() then
			make_snapshot()
		end
	end;
	dsc = [[El tercer piso de la casa era el último. Estoy en el pasillo que corre a lo largo de toda la longitud del edificio. Las puertas de las habitaciones estan todas ubicadas al mismo lado.]];
	exit = function(s, t)
		if not dog:dead() then
			if dog.down then
				if t == sleeping and not sleeping.broken then
					p [[Tiré del pomo de la puerta -- ¡¡¡cerrado!!!]];
					door34:enable()
					return false
				end
				p [[Cuando estaba a punto de abandonar la sala, oí detrás de mí una respiración pesada. Me volví rápidamente y me di cuenta de que era demasiado tarde... La maldita cosa de alguna manera seguía viva y lista para dar el mordisco final...]];
				lifeoff(dog);
				gameover = true
				stop_sound(3)
				walkin 'dogend'
				return
			end

			if t == floor2 then
				p [[Sin dudarlo, me precipité hacia atrás. Mientras caminaba por las escaleras, un perro gigante me ha adelantado.]];
				lifeoff(dog);
				gameover = true
				stop_sound(3)
				walkin 'dogend'
				return
			end

			if s.from == 'n' then
				if t == toilet then
					return
				end
				p [[Mientras llego a la puerta, ¡¡¡esa cosa llega hasta mí!!!]];
				return false
			else
				if t == sleeping then
					p [[Tiré del pomo de la puerta de la izquierda - ¡¡¡cerrado!!!]];
					door34:enable()
					return false
				end
				p [[Mientras llego a la puerta, ¡¡¡esa cosa me alcanza!!!]];
				return false
			end
		end
	end;
	obj = { windows([[A través de la ventana empapada por la lluvia en la pared este, penetra la luz al pasillo.]], [[La lluvia no se detiene...]], [[Desde el tercer piso puedo romperme las piernas.]]), 
		dog, medal, doors3, 'door34', 'luk' };
	way = { vroom('Abajo', floor2), d31, d32, d33, d34 };
}

door34 = obj {
	nam = 'Puerta 4';
	dsc = function(s)
		if floor3.from == 'n' then
			p [[La {Puerta 4} está cerrada con llave.]]
		else
			p [[La {Puerta 1} está cerrada con llave.]]
		end
	end;
	useit = [[Esta puerta está cerrada.]];
	exam = [[Puerta de madera de color marrón oscuro.]];
}:disable()

hclock = obj {
	nam = 'reloj de bolsillo';
   dsc = [[En los cajones hay un {reloj de bolsillo}.]];
	exam = function(s)
		if not have(s) then
			return 'Reloj de bolsillo con números romanos.';
		end
		if not disabled(foto) then
			p 'Examiné el reloj. ¡¡¡Es similar al que he visto en la foto!!!';
		end
		p "Hermoso. Creo que su mecanismo está en perfecto estado, igual que su aspecto exterior."
	end;
	useit = [[Hum... Puse el reloj en la oreja... Parado... 5:32..]];
	nouse = [[Mirarlo no ayudará.]];
	take = takeit [[Tomé el reloj.]];
}

sleeping = room {
	nam = 'dormitorio';
	pic = 'gfx/28.png';
	var { broken = false };
	enter = function(s)
		if not s.broken then
			p [[No puedo. La puerta está cerrada.]]
			door34:enable()
			return false
		end
	end;
	dsc = [[Una habitación espaciosa y bien amueblada. Es probable que esta sala sirva de dormitorio principal.]];
	obj = {
		obj {
			nam = 'cama';
		        dsc = [[Una {cama} ancha ocupa el centro de la habitación.]];
			exam = [[Parece muy suave.]];
			useit = function(s)
				if disabled(brother) then
					p [[Pronto estará oscuro, tengo que encontrar a Andrés.]];
				else
					p [[Tengo que encontrar una manera de abrir la puerta.]]

				end
			end
		};
		obj {
			nam = 'armario';
		        dsc = [[A mi derecha hay un {armario} de ropa.]];
			exam = [[La caja grande de madera cuelga amenazadoramente sobre mí.]];
			useit = [[Abri el armario y miré en su interior. Trajes negros colgaban en sus perchas. Una gran cantidad de trajes negros. Cerré la puerta.]];	
		};
		obj {
			nam = 'Vestidor';
		   dsc = [[Al lado de la cama hay un {vestidor} de espejo de tres caras.]];
			exam = function(s)
				if hclock:disabled() then
					p [[Me dí cuenta de que hay un objeto en el vestidor.]];
					hclock:enable();
				else
					p [[Espejos que se reflejan uno en el otro...]];
				end
			end;
			useit = [[He examinado los cajones del vestidor, y no encontré nada interesante.]]
		};
		hclock:disable();
		windows("La {ventana} mira hacia el lado oeste.","He visto lo suficiente de este paisaje.","¿Que sentido tiene abrir la ventana?");
		
	};
	way = { vroom('Al pasillo', 'floor3') };
}

vantuz = obj {
	var { kiy = false, meat = false };
	nam = function(s)
		if s.kiy then
			p 'desatascador de taco de billar';
		else
			p 'desatascador'
		end
	end;
	dsc = [[Bajo el fregadero hay un {desatascador}.]];
	take = takeit [[Cuando tomé el desatascador, tuve la extraña sensación de que sin duda me resultaría útil.]];
	useit = [[¿Algo para empujar?]];
	exam = function(s)
		p [[Robusto mango de madera y una gran ventosa de goma negra - ¡un mecanismo fiable!]];
		if s.kiy then
			p [[Se fija con cinta adhesiva en el extremo del taco de billar.]]
		end
	end;
	nouse = [[¿Empujar?]];
	use = function(s, w)
		if w == kiy then
			return w:use(s)
		end

		if (w == dog and dog.down) or nameof(w) == 'babosa' or nameof(w) == 'grumos' then
			s.meat = true
			p [[Unté el extremo de goma del desatascador.]]
			return
		end

		if w == luk then
			if not s.kiy then
				return [[No alcanza.]];
			end
			if spider1:dead() then
				p [[Abrí de nuevo la escotilla con el desatascador. No pasó nada.]]
				return
			end
			if not s.meat then
				p [[Tomé un taco de billar desatascador y abrí la escotilla. No pasó nada. Cerré la escotilla discretamente.]];
				return
			else
				p [[Tomé la escopeta en la mano derecha, y el desatascador en la izquierda, y con mucho cuidado abrí la escotilla.]];
				p [[De repente, mi brazo tembló. En el extremo del desatascador, agarrando con sus patas peludas, ¡estaba sentada una araña roja!]];
				lifeon(spider1)
				put(spider1);
			end			
		end
	end;
}:disable()

bath = room {
	nam = 'Cuarto de baño';
	pic = 'gfx/27.png';
	dsc = [[Estoy en el cuarto de baño.]];
	obj = { 
		obj {
			nam = 'Cuarto de baño';
			dsc = [[En la pared hay un cuarto de {baño}.]];
			exam = [[¿Bronce? Pies de estilo barroco.]];
			take = [[¿Llevarlo conmigo? No hay nada más fácil.]];
			useit = [[No hay agua.]];
		};
		obj {
			nam = 'lavabo';
		   dsc = [[A la izquierda está la pileta del {lavabo}]];
			exam = function(s)
				if disabled(vantuz) then
					p [[He encontrado el desatascador bajo el fregadero.]];
					vantuz:enable();
				else
					p [[Lavabo limpio.]];
				end
			end;
			useit = [[La casa no tiene agua.]];
		};
		vantuz,
		obj {
			nam = 'espejo';
		        dsc = [[En la pared hay un gran {espejo} mosaico.]];
			exam = [[Un espejo grande, como todos los accesorios en la casa.]];
			useit = [[Miré al espejo, vi una cara cansada y desconocida.]];
			take = [[No quiero llevarlo conmigo.]];
		};
		windows ([[El baño tiene una {ventana}.]], [[Ventana cerrada.]], [[Esta atracción anómala hacia las ventanas empieza a asustarme.]]);
	};
	way = { vroom('Al pasillo', 'floor3') };
}

bossdoor = obj {
	nam = 'puerta';
        dsc = [[La {puerta} que conduce al pasillo está llena de agujeros.]];
	exam = [[Seis agujeros. Curiosamente las bisagras en el marco de la puerta han estallado.]];
	useit = [[Parece que el bloqueo de la puerta estallado rebote fuera.]];	
}

revol = obj {
	nam = 'revolver';
	var { armed = false, ammo = 0 };
	dsc = [[En el suelo yacía un {revólver},]];
	take = takeit [[Tomé el revolver conmigo.]];
	exam = function(s)
		if not have(s) then
			p [[El revolver está en el centro de la habitación.]]
			return
		end
		p [[Revolver de calibre 38.]]
		if not s.armed then
			p [[Tambor vacío para seis cartuchos.]]
			return
		end
		if s.ammo == 1 then
			p [[El primer cartucho del tambor.]]
		elseif s.ammo == 5 then
			p [[El tambor tiene cinco rondas.]]
		else
			p([[El tambor ]], s.ammo, [[ cartuchos.]]);
		end
	end;
	useit = function(s)
		p [[Creo que tiene una buena repetición, pero es más difícil apuntar.]]
	end;
	shot = function(s) s.armed = false; add_sound 'snd/revol.ogg' end;
	use = function(s, w)
		if not s.armed then
			return [[El revólver no estaba cargado.]], false;
		end
		if w == spider1 then
			if w:dead() then
				return [[Mejor que cuides la munición. No hay mucha.]]
			end
			gameover = true
			p [[Traté de agarrar el arma del bolsillo, pero no pude...]]
			lifeoff(spider1)
			lifeoff(pila)
			stop_sound(3)
			walkin 'spiderend2'
			return
		end
		if w == door34 then
			if not dog.down then
				return [[Mientras disparo a través de la puerta, me va a comer.]];
			end
			return [[Es mejor usar una escopeta.]]
		end;
	end;
	nouse = [[¿Golpear el revolver?]];
}

foto3 = obj {
	nam = 'foto';
	dsc = [[En la pared cuelga una gran {foto} enmarcada.]];
	exam = function(s)
		p [[La foto en el marco masivo muestra a un hombre con una barba rala y un perro -- un rottweiler. El perro levantado sobre sus patas traseras apoya las manos sobre los hombros de un hombre lamiendo su cara. El Hombre sonrie. Del collar del perro cuelga una medalla.]];

		if taken(medal) then
			p [[Estoy unos minutos mirando al cuadro.]]
			p [[Extraños pensamientos vienen a mi cabeza. Pensé que este perro no tiene la culpa de lo que le pasó. Me dolió.]];
		end
	end;
	useit = function(s)
		if not visited 'safe' then
			p [[Estudié cuidadosamente la imágen ¡y no fue en vano! El cuadro se inclina hacia atrás a un lado. Detrás se ocultaba una caja de seguridad.]];
		else
			p [[Fui a la caja fuerte.]]
		end
		walkin 'safe'
	end;
	take = [[Demasiado grande para llevarlo conmigo.]];
}

mkeys = obj {
	nam = 'llaves';
        dsc = [[En el cajón hay unas {llaves}.]];
	exam = [[¡En mi opinión se trata de las llaves del coche!]];
	take = takeit [[Tomé las llaves de la caja.]];
	useit = [[¡Ahora sé como vamos a salir de aquí!]];
	use = function(s, w)
		if w == car or w == card then
			return [[¡¡¡Sólo me iré con mi hemano!!!]];
		end
	end;
	nouse = [[No es lo adecuado.]];
}

bossr = room {
	nam = 'gabinete';
	pic = 'gfx/29.png';
	entered = function(s)
		if not visited() then
			p [[Al entrar en ésta habitación me di cuenta de que la puerta estaba entreabierta...]];
		end
	end;
	dsc = [[Es muy probable que la amplia habitación en la que estoy haya servido de oficina al dueño de la casa.]];
	obj = { windows("La ventana de la habitación esta {rota}.","Ventana rota, a través de la cual entra la lluvia en la habitación.","Me acerqué a la ventana y miré hacia abajo. No observé nada raro.");
			obj {
                                nam = 'mesa';
			   dsc = [[Cerca de la ventana hay una enorme {mesa}.]];
				exam = [[En la mesa del comedor. Una pila de papeles caidos y un tintero derramado...]];
				useit = function()
					p [[Abrí un cajón.]];
					if mkeys:disabled() then
						p [[¡Algunas llaves!]];
						mkeys:enable()
					else	
						p [[Vacío.]];
					end
				end;
				obj = {
					mkeys:disable()
				}
			};
			obj {
				nam = 'papeles';
			   dsc = [[Hay {papeles} dispersos por toda la habitación.]];
				exam = [[Pienso que el viento que entra a través de la ventana rota barrió la mesa.]];
				useit = [[Examiné unas pocas páginas. ¿Algunas fórmulas químicas?]];
				take = function(s)
					if disabled(brother) then
						p [[Yo no lo necesito. Necesito encontrar a mi hermano.]];
					else
						p [[Es poco probable que los necesite.]];
					end
				end
			};
			revol,
			foto3, 
			bossdoor,
	};
	way = { vroom('Al pasillo', 'floor3') };	
}

function val(n)
	local v = {}
	v.nam = n
	v._state = rnd(10) - 1;
	v.dsc = function(s)
		p("{",v._state,"}");
	end
	v.exam = function(s)
		p ("El mango se puso en la posición de ",s._state, ".")
		s:useit();
	end;
	v.useit = function(s)
		s._state = s._state + 1
		if s._state == 10 then
			s._state = 0;
		end
		p "Giré el mando a la posición siguiente."
	end
	return obj(v)
end

patron = obj {
	nam = 'Munición de 9mm';
	dsc = [[en el fondo del seguro hay {cartuchos} de revolver.]];
	take = takeit [[Tomé las balas.]];
	useit = [[Pues bien, ¡los encontré!]];
	exam = [[Munición de 9mm. Diámetro óptimo. Por desgracia en la caja sólo hay cinco balas.]];
	use = function(s, w)
		if w == revol then
			p [[La caja sólo tenía cinco balas. Cargué el arma.]]
			w.armed = true
			w.ammo = 5
			remove(s, me())
			return
		end
		return [[Esta munición es para revólver.]]
	end
}

insafe = obj {
	nam = 'En la caja fuerte';
	dsc = function(s)
		p [[En la caja fuerte hay lingotes de {oro}.]];
	end;
	exam = [[Oro. Está lleno de lingotes de oro.]];
	take = [[Mi primer impulso fue tomar un par de barras, pero luego me di cuenta de que era oro nazi.]];
	useit = function(s)
		if not patron:disabled() then
			p [[En la caja fuerte no hay nada más que sea interesante.]]
		else
			p [[Moví algunas barras a un lado y me dí cuenta de que al fondo de la caja de seguridad ¡hay munición para la pistola!]];
			patron:enable()
		end
	end;
	obj = {
		patron:disable(),
	}
}:disable();


safe = room {
	var { opened = false; };
	nam = 'La caja fuerte';
	pic = function(s)
		if s.opened then
			return 'gfx/30a.png'
		else
			return 'gfx/30.png'
		end
	end;
	dsc = "La caja parece segura.";
	obj = {
		obj {
			nam = 'puerta';
		   dsc = 'Estoy junto a la firme {puerta} de metal. En el tirador hay mandos para introducir una contraseña de ocho dígitos:';
			exam = [[No ayuda mucho...]];
			useit = function(s)
				if safe.opened == true then
					return "¡Caja de seguridad abierta!";
				end
				if objs()[2]._state == 1 and
					objs()[3]._state == 8 and
					objs()[4]._state == 8 and
					objs()[5]._state == 9 and
					objs()[6]._state == 1 and
					objs()[7]._state == 9 and
					objs()[8]._state == 4 and
					objs()[9]._state == 5 then
					safe.opened = true
					insafe:enable();
					return "¡Tiré de la manija de la caja de seguridad y se abrió la puerta!";
				end
				return "No abre.";
			end;
		};
		val('1'); val('2'); val('3'); val('4');
		val('5'); val('6'); val('7'); val('8');
		insafe;
	};
	way = { vroom('Volver', 'bossr')};
}

spider1 = obj {
	var { killed = false, trigger = false };
	nam = 'araña';
	dsc = function(s)
		if s.killed then
		        return [[Bajo la escotilla en el suelo yacían los restos de una {araña}.]];
		end
		p (txtem [[¡Sobre el desatascador hay una {araña}!]]);
	end;
	take = [[No, gracias.]];
	useit = [[Es difícil encontrar un uso.]];
	exam = function(s)
		if s.killed then
			p [[¡Se rompió en pedazos! Sólo quedaron patas peludas.]];
		else
			p [[¡¡¡Ahora me dió!!!]]
		end
	end;
	dead = function(s) return s.killed end;
	kill = function(s)
		lifeoff(s)
		s.killed = true
		make_snapshot()
	end;
	life  = function(s)
		if not s.trigger then
			s.trigger = true
			return [[¡¡¡Ahora la araña me atacó!!!]];
		end
		lifeoff(s);
		lifeoff(pila)
		gameover = true
		stop_sound(3)
		walkin 'spiderend2';
	end;
}

luk = obj {
	nam = 'escotilla';
	door_type = true;
        dsc = 'En el lado norte del corredor, está la {escotilla} del techo.';
	exam = [[Esto conduce a la buhardilla. Al lado de la pequeña escotilla hay una escala.]];
	useit = function(s)
		if not dog.down then
			p [[¡Mientras subo las escaleras el monstruo me alcanza!]];
			return
		end
		if not spider1:dead() then
			gameover = true;
			lifeoff(dog)
			lifeoff(pila)
			stop_sound(3)
			walkin 'spiderend'
			return
		end
		p [[Empecé a subir la escalera. Al llegar a la escotilla, la empujé y subí al ático.]]
		walk 'floor4';
	end
}

antifire = obj {
	nam = 'extintor';
	dsc = function(s)
		if here() == floor4 then
		   p [[Tirado en el suelo hay un {extintor} vacío.]]
		else
		   p [[En la esquina se encuentra un {extintor}.]];
		end
	end;
	take = function(s)
		if here() == floor4 then
			return [[Lo he utilizado.]]
		end
		p [[Tomé el extintor.]];
		return true
	end;
	useit = function(s)
		if not have(s) then
			return [[No lo tomé.]]
		end
		p [[Ningún fuego. Mientras tanto...]];		
	end;
	exam = [[Cilindro de hierro con una red.]];
	nouse = [[No es necesario apagarlo.]];
}

lab = room {
	nam = 'En el laboratorio';
	pic = function(s)
		if seen 'mesa'.broken then
			return 'gfx/23a.png'
		else
			return 'gfx/23.png'
		end
	end;
	dark = true;
	dsc = [[Estaba en una habitación bastante grande, que ocupaba casi todo el espacio bajo la chimenea.]];
	exit = function(s)
		if not seen 'mesa'.broken or not seen 'bombona'.broken then
			p [[Creo que, antes de salir, usted debe destruir el mal. Es posible que no pueda volver aquí otra vez.]];
			return false
		end
	end;
	obj = {
		obj {
			var { broken = false };
			nam = 'mesa';
			dsc = function(s)
				if s.broken then
				   p [[En una larga {mesa} hay un caos de cristales rotos.]];
				else
				   p [[Hay una larga {mesa}, con algunos dispositivos sobre ella.]];
				end
			end;
			exam = function(s)
				if s.broken then
					p [[Sobre la mesa un lecho de trozos de plástico y vidrios rotos. Hice un buen trabajo.]];
				else
					p [[Los conos, tubos con líquido verde, algunos dispositivos extraños...]];
				end
			end;
			used = function(s, w)
				if w == pila or w == shotgun then
					if s.broken then
						return [[Destruye el mal.]];
					end
					if w == pila then
						add_sound 'snd/chain3.ogg'
						p [[Sin dudarlo, me puse a destruir todo lo que estaba sobre la mesa.]]
					else
						shotgun:shot()
						p [[Tiré a la bombona de cristal con una escopeta, y luego comencé a destruir lo que quedaba...]]
						p [[Un tintineo de cristales rotos llenó la habitación.]]
					end
					add_sound 'snd/crash.ogg'
					s.broken = true
				end
			end;
			take = [[No necesito todo esto.]];
			useit = [[Aquí esta el mal -- creí.]];
		};
		obj {
			nam = 'bombona';
			var { broken = false };
			dsc = function(s)
				if s.broken then
					return [[Por todo el laboratorio hay vidrios rotos y restos de {criaturas}.]];
				end
				p [[En los estantes a lo largo de las paredes hay {bombonas} de vidrio.]];
			end;
			exam = function(s)
				if s.broken then
					return [[Ellos no tienen la culpa de lo que habían llegado a ser. Esta casa era un lugar de miedo, espero que mi hermano esté bien.]]
				end
				p [[En frascos grandes, veo algunas cosas extrañas.. Es mejor que me mantenga alejado de ellos...]];
			end;
			take = [[No necesito ninguna basura.]];
			useit = [[No hay necesidad de tocarlo.]];
			used = function(s, w)
				if w == pila or w == shotgun then
					if s.broken then
						return [[Destruye el mal.]];
					end
					add_sound 'snd/chain3.ogg'
					if w == pila then
						p [[Sin dudarlo, comencé a romper el botellón.]]
						p [[Las criaturas estaban vivas, y trataron de salir de entre los cristales rotos, pero esta vez no tuvieron oportunidad de hacerlo.]]
						s.broken = true
					else
						p [[Disparé con una escopeta en uno de los frascos, y se rompió en fragmentos diminutos. La criatura de dentro estaba viva y me atacó. Afortunadamente, fui capaz de encender la motosierra.]]
						shotgun:shot()
						pila.on = true
						lifeon(pila)
						s.broken = true
						p [[Entoncés pasé a la siguiente botella... Después de unos minutos todo había terminado.]];
					end
					add_sound 'snd/crash.ogg'
				end
			end;
		};
		obj {
			nam = 'puerta';
			door_type = true;
		        dsc = [[En el muro norte se encuentra la {puerta} de acero.]];
			exam = [[Parece que esta puerta conduce a la bodega, donde vi los cubos de esa basura verde.]];
			useit = [[Es mejor no abrir, todo se inundará del maldito limo verde en barricas.]];
		};
		antifire,
	};
	way = { vroom('Afuera', lroom) };
}

spider = obj {
	var { killed = false, step = 1, shotgun = 0, revol = false, pila = false };
	dead = function(s)  return s.killed end;
	nam = 'araña';
	useit = function(s)
		p[[Es difícil encontrar un uso a ]];
		if s.killed then
			p [[una araña muerta.]]
		else
			p [[una araña gigante.]];
		end
	end;
	exam = function(s)
		if s.pila then
			return [[Incluso los restos de una araña parecen siniestros.]];
		end
		if s.killed then
			return [[Parece muerta, pero yo prefiero quedarle lejos de ella.]];
		end
		return [[¡¡¡Esta araña es mucho más granque que la primera!!! ¡¡¡Es enorme!!!]];
	end;	
	dsc = function(s)
		if s.pila then
		   return [[Ante la escotilla que lleva a la tercera planta están los restos de una {araña}.]];
		end
		if s.killed then
			return [[Ante la escotilla que baja a la tercera planta, hay una {araña} muerta.]];
		end
		if s.step == 2 then
		   p [[En el techo inclinado de la buhardilla, cerca de mí, ¡hay una {araña} enorme!]];
		elseif s.step == 3 then
			p [[La {araña} se está moviendo muy rápido, distingo el pelo que le cubre la gorda tripa.]];
		elseif s.step == 4 then
		   p (txtem([[La {araña} está delante de mí. ¡Con sus terribles mandíbulas goteando baba verde!]]));
		elseif s.step == 6 then
			p [[La {araña} se está moviendo muy rápido, ¡¡¡advierto sus ojillos malignos!!!]];
		elseif s.step == 7 then
			p (txtem([[La {araña} está delante de mí. ¡Con sus terribles mandíbulas goteando baba verde!]]));
		end
	end;
	life = function(s)
		if s.step == 1 then
			p [[¡¡¡Oigo el murmullo silencioso con el que la araña se mueve a lo largo del techo del ático!!!]];
		elseif s.step == 2 then
			p [[La araña se me acerca. ¡¡¡Es enorme!!!. Me pregunto ¿cómo se las arregla para arrastrarse sobre el techo inclinado?]];
		elseif s.step == 3 then
			p [[¡Creo que me está atacando!]];
		elseif s.step == 4 or s.step == 7 then
			gameover = true
			lifeoff(s)
			lifeoff(pila)
			stop_sound(3)
			walkin 'spiderend3'
			return
		elseif s.step == 5 then
			p [[La araña se acercaba rápidamente. ¡¡¡Es enorme!!!]];
		elseif s.step == 6 then
			p [[¡Creo que me está atacando!]];
		end
		s.step = s.step + 1
	end;
	kill = function(s)
		s.killed = true
		lifeoff(s)
	end;
	used = function(s, w)
		if w == pila then
			if s.pila then
				return [[No soy un carnicero.]]
			end
			if s.killed then
				s.pila = true
				add_sound 'snd/chain3.ogg';
				return [[Ahora ya no puede hacer daño.]]
			end
			return [[Me temo que el acero frío no ayuda.]]
		end
		if s.step == 7 then
			if w == shotgun  then
				w:shot()				
				p [[Acabo de descargar la escopeta en la cabeza de una araña terrible.]]
				if s.shotgun == 1 and s.revol then
					p [[La araña sacudió de forma terrible todo su cuerpo rojo, avanzó otro paso y, finalmente, quedó inerte.]]
					s:kill()
				else
					p [[Pero la maldita cosa se me echó encima...]]
					gameover = true
					lifeoff(s)
					stop_sound(3)
					walkin 'spiderend3'
				end
				return
			elseif w == revol then
				w:shot()
				p [[Vacié la pistola en la cabeza de una araña terrible.]]
				if s.shotgun == 2 then
					p [[La araña sacudió todo su cuerpo rojo terrible, dio un paso más, y finalmente quedó inerte.]]
					s:kill();
				else
					p [[Pero la maldita cosa se echó sobre mí...]]
					gameover = true
					lifeoff(s)
					stop_sound(3)
					walkin 'spiderend3'
				end
				return
			end
		end
		if w == shotgun then
			if s.step == 4 then
				p [[Descargué el arma en una araña gigante, pero ya era demasiado tarde...]]
				w:shot()
				lifeoff(s)
				gameover = true
				stop_sound(3)
				walkin 'spiderend3'
				return
			end
			p [[Descargué la escopeta en la araña gigante. Le dí, a juzgar por las salpicaduras verdes que salieron de su masa corporal, pero siguió avanzando.]]
			s.shotgun = s.shotgun + 1
			w:shot()
			return
		end
		if w == revol then
			p [[Saqué el revólver y disparé todo el tambor en una criatura terrible, bala por bala.]];
			if s.step == 4 then
				p [[Pero ya era demasiado tarde...]]
				lifeoff(s);
				gameover = true
				stop_sound(3)
				walkin 'spiderend3'
				return
			end
			if s.step == 2 then
				w:shot()
				p [[¡Desafortunadamente la distancia a la araña era demasiado grande, y el tiro se perdió!]];
			else
				p [[La araña se estremeció, pero tras una pausa continuó su terrible ataque.]]
				w:shot()
				s.revol = true;
			end
			return
		end
		if w == antifire then
			if w.empty then
				return [[El extintor está vacío.]];
			end
			w.empty = true
			drop(w);
			add_sound 'snd/antifire.ogg'
			if s.step == 4 then
				p [[¡¡¡Rompí el sello en el extintor y lo golpeé en el suelo enviando una corriente chisporroteante a la gorda bestia!!! La araña se desprendió del techo con un ruido sordo y corrió hacia la parte trasera de la buhardilla. Durante un rato observó, centrando sus ojos malignos en la espuma que salía del extintor, luego empezó otra vez a acercarse rápidamente a mí...]]
				s.step = 5
			else
				p [[Rompí el sello en el extintor y lo golpeé en el suelo comenzando a llenar el ático con espuma. Pero la araña estaba demasiado lejos y seguía viniendo hacia mí.]];

			end
		end
	end;
}

brother = obj {
	nam = 'hermano';
	var { web = true };
	dsc = [[¡Tras una de las cajas he encontrado a mi {hermano}!]];
	exam = function(s)
		if s.web then
			p [[Estaba todo enredado en la tela de hilos gruesos y pegajosos.]];
			return
		end
		if not have(s) then
			p [[Mi hermano estaba tendido cerca de las malditas cajas.]];
			return
		end
		return [[Abrazo a mi hermano.]];
	end;
	useit = function(s)
		if s.web then
			p [[Lo sacudí y grité: ¡¡¡Andrés!!! El sonido de mi voz se ahogó rápidamente por el tamborileo de la lluvia torrencial sobre el tejado.]]
			return
		end
		if not have(s) then
			p [[Sentí su pulso. Era raro y débil, pero ¡mi hermano menor estaba vivo!]];
			return
		end
		return [[Pasé el brazo alrededor de mi hermano. ¡¡¡Todo estará bien!!!]]
	end;
	used = function(s, w)
		if w == shotgun or w == pila then
			return [[Estas ideas sugeridas por el diablo...]];
		end
	end;
	take = function(s)
		if s.web then
			p [[Quería alzar a mi hermano sobre mis hombros, pero estaba completamente enredado en una maraña espesa y pegajosa. ¡Es preciso liberarlo de ella!]];
			return
		end
		if not have(mkeys) then
			p [[Antes de partir de aquí, usted necesita encontrar una manera de abrir la puerta. Y aquí sólo está relativamente seguro.]]
			return
		end
		p [[Alcé al hombro a mí hermano.]];
		lifeoff(music_player)
		timer:stop()
		set_music('mus/13 Heart on fire.ogg');
		return true
	end;
}
boxes = obj {
	nam = 'cajas';
        dsc = [[En el ático hay un montón de {cajas} de madera.]];
	used = function(s, w)
		if not spider:dead() then
			return [[Mejor pensar en mi mismo.]]
		end
		if w == shotgun or w == pila then
			if brother:disabled() then
				return [[Ya las he visto. Mejor encuentro a mi hermano.]]
			end
			return [[¡¡¡Encontré a mi hermano!!! Ya no me importan nada estas cajas.]];
		end
	end;
	useit = function(s)
		if not spider:dead() then
			p [[¡Es tarde para ocultarse!]];
			return
		end
		if not spider.pila then
			lifeoff(spider);
			gameover = true
			stop_sound(3)
			walkin 'spiderend3'
			return [[Comencé a inspeccionar las cajas cuando oí un crujido detrás de él. ¡¡¡Me di la vuelta para ver que cosa maldita seguía con vida!!!]];
		end
		if disabled(brother) then
			p [[Comencé a deambular entre cajas en un rincón de la buhardilla hasta que noté una silueta.]];
			p [[Me acerqué. ¡¡¡Era mi hermano!!! Enredado en una tela gruesa, que no daba señales de vida.]]
			brother:enable()
			return
		end
		return [[Al fin, ¡¡¡me encontré con mi hermano!!!]];
	end;
	exam = function(s)
		p [[Cajas de madera. Muchas de ellas sujetas con cadenas cerradas por candados.]]
	end;
	obj = { brother:disable() };
}

floor4 = room {
	nam = 'En el ático';
	pic = function(s)
		if have (brother) then
			return 'gfx/32.png'
		end
		if spider:dead() then
			return 'gfx/31e.png'
		end
		if spider.step == 2 then
			return 'gfx/31.png'
		elseif spider.step == 3 then
			return 'gfx/31a.png'
		elseif spider.step == 4 then
			return 'gfx/31b.png'
		elseif spider.step == 6 then
			return 'gfx/31c.png'
		elseif spider.step == 7 then
			return 'gfx/31d.png'
		end
	end;
	dark = true;
	dsc = [[Yo estaba en el ático de la mansión. Sobre mí, los planos inclinados de los techos son muy altos. Estaba oscuro y húmedo, a través de la ventana rota del ático irrumpió el viento.]];
	entered = function(s)
		if not flash.on then
			p [[Estaba muy oscuro y yo encendí la linterna.]]
			flash.on = true
			lifeon(flash)
		end
		if not spider:dead() then
			lifeon(spider);
			p [[Una vez en el ático, encendí la linterna... Mi corazón se detuvo, y luego comenzó a latir rápidamente. El haz de la linterna se reflejaba en los pequeños ojos de una criatura malvada y gorda, ella me vio y comenzó a aproximarse. Una araña gigante, varias veces más grande que la que maté, moviendo sus piernas peludas, se arrastró por el techo inclinado del extremo de la buhardilla...]]
		end
	end;
	exit = function(s, t)
		if have 'brother' then gameover = true lifeoff(pila) stop_sound(3) walkin 'happyend' return end
		if not spider.killed then
			lifeoff(spider);
			gameover = true
			stop_sound(3)
			walkin 'spiderend3'
			return [[Al ver que yo estoy tratando de huir, la araña saltó bruscamente hacia adelante. Se las arregló para cerrar la escotilla...]];
		end
		if not spider.pila then
			lifeoff(spider);
			gameover = true
			stop_sound(3)
			walkin 'spiderend3'
			return [[Empecé a bajar a la tercera planta, cuando escuché un crujido detrás de él. Me di la vuelta para ver que otra cosa maldita estaba con vida...]];
		end
	end;
	obj = { spider, boxes, windows([[Una {ventana} redonda dividida, tipo tragaluz.]], [[Ventana bajo la lluvia torrencial.]], [[¡¡¡Parece una ventana rota!!!]]),
			obj {
				nam = 'huesos';
				dsc = [[Cerca de la ventana hay un montón de {huesos}.]];
				exam = [[Me da miedo imaginar de quien son esos huesos.]];
				take = [[¡No los necesito!]];
				useit = [[¿Cómo?]];
			} };
	way = { vroom('Abajo', floor3) };
}

happyend = room {
	nam = 'Fin';
	pic = 'gfx/33.png';
	hideinv = true;
	forcedsc = true;
	dsc = function(s)
		p [[Cruzamos por el puente en coche cuando vi el pálido rostro de Andrés en el retrovisor.^
		-- ¿A donde vamos?
		-- A casa.^
		 Hizo una pausa, mirando a la oscuridad detrás del cristal.^
		-- ¿Este es el coche de la mansión?^
		-- Sí, tenía que abrir la puerta de alguna manera... Lo tengo entonces... prestado.^
		-- ¿Qué fue lo que me pasó?^
		-- ¿No te acuerdas de nada?^
		-- Sí, me subí a un árbol encima de la cerca -- su voz era culpable -- y luego miró a la ventana.^
                -- Fuí hasta la puerta delantera, y luego... es como si algo hubiera caido sobre mí desde la parte superior. Entonces...^
		-- ¿Qué pasó entonces?^
		-- No sé, parece que recuerdo un lugar oscuro... Creo que... No sé...^ 
                -- Su cara era la pregunta escrita, -- ¿Dónde me encontraste?^
		-- Te encontré en la puerta, puede que hayas perdido el conocimiento.^ 
                -- Estabas cerca del marco de la ventana rota, debe de haberte golpeado la cabeza.^ No deberías haber ido allí, Andrés, 
                 Traté de que mi voz sonara estricta.^
		-- Yo sé qué soy culpable. ¿Crees que nuestro padre se enojará?^
		-- Papá te quiere Andrés.^
		-- ¿Que le dirás?^
		-- Lo mismo que me estás contando a mí.^
		 El rostro de su hermano en el retrovisor se oscureció durante un momento, luego adoptó una expresión de calma.^ 
                 Sus ojos estaban tristes pero se sentía feliz.^
		-- Sí bueno.^
		]];

		if taken(cap) then
			p [[-- Cerca de tí encontré esto, -- le entregué la gorra.^
			-- ¡Gracias!]]
		end
		p [[Nos quedamos en silencio.^
			-- ¡Iván!^
			-- ¿Qué?^
			-- Se ha ensuciado un poco en una parte. Pintura verde...^
			-- ¿Sí? No tengas miedo... lo lavamos en casa...]];
	end;
	obj = { obj {
		nam = 'seguir';
		dsc = [[{seguir}]];
		act = code [[ me():disable_all(); walk 'titles']];
	} };
}

titles2 = room {
	nam = '...';
	hideinv = true;
	forcedsc = true;
	dsc = function(s)
		local k,v
		local center = true
		for k,v in ipairs(titles.txt) do
			if v == 'center' then center = true
			elseif v == 'left' then center = false
			else
				if center then
					pn(txtc(v))
				else
					pn(v)
				end
			end
		end
	end;
}
titles = room {
	nam = '';
	hideinv = true, 
	txt = { 
 		"Programación e ilustraciones:", 
  	        "Петр Косых (Peter Kosyh)", 
		" ",
		"Ilustración para el diseño del fondo:",
		"http://fromoldbooks.org",
		" ",
		"Мúsica:",
		"Александр Соборов (excelenter)",
		"http://electrodnevnik.ru",
		" ",
		"Sonidos:",
		"http://www.freesound.org",
		" ",
		"Motor INSTEAD:",
		"Петр Косых (Peter Kosyh)",
		"http://instead.syscall.ru",
		" ",
		" ",
		"El guión ha sido influenciado por los siguientes juegos:",
		"Maniac Mansion by Lucasfilm",
		"Malstrum's Mansion by ACE Team",
		"Проклятое наследство // Николай Жариков",
		"Dangerous Dave 2 by Id Software",
		"Escape The Toilet // В. Подобаев",
		" ",
		"Agradecimientos:",
	        "Жене и детям (Mi mujer e hijos)",
	        "Александру Соборову (Alexander Soborov)",
	        "Вадиму Балашову (Vadim Balashoff)",
	        "Владимиру Подобаеву (Vladimir Podobaev)",
	        "Всем, кто не мешал работать (Y a todo aquel que no interfirió con el trabajo)",
		" ",
		"Traducción al castellano:",
	        "Павел Вальдес (pvaldes)",
		" ",
		" ",
		" ",
		" ",
		" ",
		"left",
		"— Iván, ¿¿¿Has oído???",
		"— ¿Qué?",
		"— ¡Esa casa se quemó hasta los cimientos! ¡No queda nada de ella!",
		"  ¡Todo el mundo dice que se prendió fuego!",
		"  Ayer, al devolver el coche ¿seguía intacta?",
		"— Hum... ¿Le dijiste a alguien lo que había pasado?",
		"— No.",
		"— Está bien, no lo cuentes. Probablemente haya sido el rayo...",
		"— ¿Un relámpago?",
		"— Sí, un rayo... sucede, de vez en cuando por supuesto, pero sucede.",
		"— Un relámpago...",
		"— Sí, claro, fue un relámpago...",
		" ",
		" ",
		" ",
		" ",
		" ",
		" ",
		"center",
		"FIN",
	};

	off = 200;
	w = 0;
	enter = function(s)
		set_music('mus/09 Good morning.ogg');
		if (PLATFORM ~= 'UNIX' and PLATFORM ~= 'WIN32') or theme:name() ~= '.' then
			return walk 'titles2';
		end
	end;
	fading = 16;
	entered = function(s)
		theme.win.geom((800 - 500) / 2, (600 - 200) / 2, 500, 200);
		theme.set('scr.gfx.bg', '');
		theme.set('scr.col.bg', 'black');
		theme.set('inv.mode', 'disabled');
		s:ini(true, true)
	end;
	timer = function(s)
		sprite.fill(SCR, 'black')
		sprite.draw(TEXT, s.pic, (500 - s.w) / 2, s.off);
		s.off = s.off - 1
		local w,h = sprite.size(TEXT)
		if s.off < -h + 100 - FH/2 then
			timer:stop()
		end
	end;
	ini = function(s, load, force)
		local k, v, h
		local spr = {};
		local w = 0
		local m = 0
		local center = true
		if (not load or not visited(s)) and not force then
			return
		end
		FN = sprite.font('gfx/sans.ttf', 16)
		SCR = sprite.load ('box:500x200,black')
		if not FN or not SCR then
			return
		end
		h = sprite.font_height(FN)
		FH = h
		for k,v in ipairs(s.txt) do
			if v == 'left' then
				table.insert(spr, v);
			elseif v == 'center' then
				table.insert(spr, v);
			else
				m = m + 1
				local t = sprite.text(FN, v, 'white');
				table.insert(spr, t);
				local ww, hh = sprite.size(t);
				if ww > w then
					w = ww
				end
			end
		end
		TEXT = sprite.load('box:'..tostring(w)..'x'..tostring(h * m)..',black');
		if not TEXT then
			return
		end
		local x, y
		y = 0
		for k, v in ipairs(spr) do
			if v == 'left' then center = false
			elseif v == 'center' then center = true
			else
				local ww, hh = sprite.size(v);
				if center then
					x = ((w - ww) / 2)
				else
					x = 0;
				end
				sprite.draw(v, TEXT, x, y);
				y = y + sprite.font_height(FN)
			end
		end
		s.w = w
		s.pic = SCR
		timer:set(60)
	end;
}
-- vim:ts=4