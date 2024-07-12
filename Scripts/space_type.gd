class_name SpaceType

enum {P_LASO, P_LOJE, P_PIMEJA, P_JELO, P_WALO}

static var SPACES = preload ("res://Assets/spaces.png")
static var OPEN: SpaceType = SpaceType.new("open", Vector2(0, 0),  "neutral")
static var TELO: SpaceType = SpaceType.new("telo", Vector2(200, 0), "telo (water) space. non-aquatic pieces may not move onto empty telo spaces or capture any pieces alone on a telo space.")
static var KASI: SpaceType = KasiSpaceType.new("kasi", Vector2(400, 0), "kasi (plant) space. after movement, a new kili is placed onto any empty kasi spaces from their respective reserves, if possible.")
static var PIMEJA: SpaceType = SpaceType.new("pimeja", Vector2(600, 100), "pimeja (black) home area space.")
static var LOJE: SpaceType = SpaceType.new("loje", Vector2(200, 100), "loje (red) home area space.")
static var JELO: SpaceType = SpaceType.new("jelo", Vector2(200, 200), "jelo (yellow) home area space.")
static var WALO: SpaceType = SpaceType.new("walo", Vector2(600, 200), "walo (white) home area space.")
static var TOMO_PIMEJA: SpaceType = SpaceType.new("tomo pimeja", Vector2(400, 100), "pimeja (black) home space. if your home space has a kili on it, you may spend a turn to exchange that kili for any captured piece of your color.", true, P_PIMEJA)
static var TOMO_LOJE: SpaceType = SpaceType.new("tomo loje", Vector2(0, 100), "loje (red) home space. if your home space has a kili on it, you may spend a turn to exchange that kili for any captured piece of your color.", true, P_LOJE)
static var TOMO_JELO: SpaceType = SpaceType.new("tomo jelo", Vector2(0, 200), "jelo (yellow) home space. if your home space has a kili on it, you may spend a turn to exchange that kili for any captured piece of your color.", true, P_JELO)
static var TOMO_WALO: SpaceType = SpaceType.new("tomo walo", Vector2(400, 200), "walo (white) home space. if your home space has a kili on it, you may spend a turn to exchange that kili for any captured piece of your color.", true, P_WALO)
static var EMPTY: SpaceType = SpaceType.new("empty", Vector2(600, 0), "_")

var name: String
var light_texture: AtlasTexture
var dark_texture: AtlasTexture
var description: String
var is_home: bool
var owner_signature: int

func _init(_name: String, _texture_position: Vector2, _description: String, _is_home: bool = false, _owner_signature:int = 0):
	name = _name
	description = _description
	light_texture = AtlasTexture.new()
	light_texture.set_atlas(SPACES)
	light_texture.region = Rect2(_texture_position, Vector2(100, 100))
	dark_texture = AtlasTexture.new()
	dark_texture.set_atlas(SPACES)
	dark_texture.region = Rect2(_texture_position + Vector2(100, 0), Vector2(100, 100))
	is_home = _is_home
	owner_signature = _owner_signature

func get_description(_board_space: BoardSpace):
	return description
