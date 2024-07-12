class_name SpaceType

enum {P_LASO, P_LOJE, P_PIMEJA, P_JELO, P_WALO}

static var OPEN = SpaceType.new("open", preload ("res://Assets/empty_dark.png"), preload ("res://Assets/empty_light.png"), "neutral")
static var TELO = SpaceType.new("telo", preload ("res://Assets/telo_dark.png"), preload ("res://Assets/telo_light.png"), "telo (water) space. non-aquatic pieces may not move onto empty telo spaces or capture any pieces alone on a telo space.")
static var KASI = KasiSpaceType.new("kasi", preload ("res://Assets/kasi_dark.png"), preload ("res://Assets/kasi_light.png"), "kasi (plant) space. after movement, a new kili is placed onto any empty kasi spaces from their respective reserves, if possible.")
static var PIMEJA = SpaceType.new("pimeja", preload ("res://Assets/pimeja_dark.png"), preload ("res://Assets/pimeja_light.png"), "pimeja (black) home area space.")
static var LOJE = SpaceType.new("loje", preload ("res://Assets/loje_dark.png"), preload ("res://Assets/loje_light.png"), "loje (red) home area space.")
static var TOMO_PIMEJA = SpaceType.new("tomo pimeja", preload ("res://Assets/tomo_pimeja_dark.png"), preload ("res://Assets/tomo_pimeja_light.png"), "pimeja (black) home space. if your home space has a kili on it, you may spend a turn to exchange that kili for any captured piece of your color.", true, P_PIMEJA)
static var TOMO_LOJE = SpaceType.new("tomo loje", preload ("res://Assets/tomo_loje_dark.png"), preload ("res://Assets/tomo_loje_light.png"), "loje (red) home space. if your home space has a kili on it, you may spend a turn to exchange that kili for any captured piece of your color.", true, P_LOJE)
static var EMPTY = SpaceType.new("empty", preload ("res://Assets/empty.png"), preload ("res://Assets/empty.png"), "_")

var name: String
var light_texture: Resource
var dark_texture: Resource
var description: String
var is_home: bool
var owner_signature: int

func _init(_name, _light_texture, _dark_texture, _description, _is_home=false, _owner_signature=0):
	name = _name
	light_texture = _light_texture
	dark_texture = _dark_texture
	description = _description
	is_home = _is_home
	owner_signature = _owner_signature

func get_description(_board_space: BoardSpace):
	return description
