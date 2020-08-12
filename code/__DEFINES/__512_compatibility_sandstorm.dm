#if DM_VERSION < 513

#define ismovable(A) (istype(A, /atom/movable))

#define islist(L) (istype(L, /list))

#define clamp(CLVALUE,CLMIN,CLMAX) ( max( (CLMIN), min((CLVALUE), (CLMAX)) ) )

#define TAN(x) (sin(x) / cos(x))

#define ATAN2(x, y) ( !(x) && !(y) ? 0 : (y) >= 0 ? arccos((x) / sqrt((x)*(x) + (y)*(y))) : -arccos((x) / sqrt((x)*(x) + (y)*(y))) )

#define arctan(x) (arcsin(x/sqrt(1+x*x)))

#else

#define TAN(x) tan(x)

#define ATAN2(x, y) arctan(x, y)

#endif

#if DM_BUILD < 1493
#define length_char(args...) length(args)
#define text2ascii_char(args...) text2ascii(args)
#define copytext_char(args...) copytext(args)
#define splittext_char(args...) splittext(args)
#define spantext_char(args...) spantext(args)
#define nonspantext_char(args...) nonspantext(args)
#define findtext_char(args...) findtext(args)
#define findtextEx_char(args...) findtextEx(args)
#define findlasttext_char(args...) findlasttext(args)
#define findlasttextEx_char(args...) findlasttextEx(args)
#define replacetext_char(args...) replacetext(args)
#define replacetextEx_char(args...) replacetextEx(args)
// /regex procs
#define Find_char(args...) Find(args)
#define Replace_char(args...) Replace(args)
#endif
