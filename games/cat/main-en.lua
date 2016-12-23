game.codepage="UTF-8";
game.act = 'Can\'t do that.';
game.inv = 'Hmm... Wrong...';
game.use = 'Won\'t work...';
game.dsc = [[Commands:^
    look (or just Enter), act <on what> (or just on what), use <what> [on what], go <where>,^
    back, inv, way, obj, quit, save <fname>, load <fname>. Tab to autocomplete.^^
Oleg G., Vladimir P., Ilia R., et al. in the science-fiction and dramatic text adventure by Pyotr K.^^
THE RETURNING OF THE QUANTUM CAT^^
Former hacker. He left to live in the forest. But he's back. Back for his cat.^^
“I JUST CAME TO GET BACK MY CAT...” ^^]];

--require "dbg";

me().nam = 'Oleg';
main = room {
	nam = 'THE RETURNING OF THE QUANTUM CAT',
	pic = 'gfx/thecat.png',
	dsc = [[
Outside my cabin the snow is white again. The wood crackles in the fireplace just like that day... It's the third winter already.
Two winters have passed, but the events I want to tell about are in front of my eyes as if it was yesterday...^^

I've been working as a forest warden over ten years. Over ten years I lived in my cabin in the woods, gathering poachers' traps and going to a nearby town once in a week or two... After a Sunday service in the local church I went to a shop to buy the stuff I needed: shotgun ammunition, groats, bread, medicaments...^^

I used to be a quite good IT specialist... But that doesn't matter anymore... I hadn't seen a computer screen for a decade and didn't regret it.^^

Now I understand that the root of those events lies as far as the early thirties... But I'd better tell everything step by step...^^

It was a cold February day, and I was preparing to go to the town as usual...]],
obj = { vobj(1,'Next','{Next}.') },
act = function()
	return walk('home');
end,
exit = function()
	set_music("mus/ofd.xm");
end,
};
set_music("mus/new.s3m");
dofile("ep1-en.lua");
dofile("ep2-en.lua");
dofile("ep3-en.lua");

--me().where = 'eside';
--inv():add('mywear');
--inv():add('gun');
--inv():add('trap');

