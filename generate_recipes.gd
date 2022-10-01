extends Node2D

class_name RecipeGenerator

enum op {WATER, HEAT, COOL, SHAKE,
 LEAF, HERB, THISTLE, FLOWER, MUSHROOM,
 GROUND_LEAF, GROUND_HERB, GROUND_THISTLE, GROUND_FLOWER, GROUND_MUSHROOM}

enum potions {HEALTH, SPEED, INVISIBLE, POWER, WATER,
SUPER_SONIC, JOE_TOES, JIM, JOM, TOM}

enum mode {EASY, MED, HARD}

var ingredients= op.values().slice(op.LEAF, op.keys().size()-1)
var operations= op.values().slice(op.HEAT, op.SHAKE)

# ordered in easy to hard potions?
var potions_recipes = {}
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# generate num_easy+num_med+num_hard recipes
func generate_recipes(num_easy, num_med, num_hard):
	
	if (num_easy+num_med+num_hard) > potions.size():
		print("warning: total num easy, med, hard potions is greater than actual potion")
	var dif = mode.EASY
	#randomize potion order
	var rand_potions = potions.values()
	rand_potions.shuffle()
	
	var recipe_len =0
	
	
	var hard_base_ingred = []
	
	for potion in rand_potions:
		#generate recipe for each potion
		#make op list, remove water,
		var recipe = []
		#generate length (based on mode)
		if dif==mode.EASY:
			
			#base
			recipe = [op.WATER]
			
			#get either one or two random ingredients
			var rand_ingreds= get_random_array(rng.randi_range(1,2),ingredients)
			recipe.append_array(rand_ingreds)
			
			#get 1 or 0 operations
			var rand_ops= get_random_array(rng.randi_range(0,1),operations)
			recipe.append_array(rand_ops)
			
		elif dif==mode.MED:
			#base (can be water or previous 
			var bases = [op.WATER]
			bases.append_array([potions_recipes.keys().slice(0,num_easy-1)])
			
			recipe = get_random_array(1,bases)
			#now mix up order of ingredients and operations
			var recipe_suffix= []
			#random ingredients
			var rand_ingred = get_random_array(rng.randi_range(2,3),ingredients)
			recipe_suffix.append_array(rand_ingred)
			
			#operations
			var rand_op = get_random_array(rng.randi_range(1,2),operations)
			recipe_suffix.append_array(rand_op)
			
			recipe_suffix.shuffle()
			
			recipe.append_array(recipe_suffix)
			
		else:
			#base (can be water or previous 
			var bases = [op.WATER]
			bases.append_array([potions_recipes.keys().slice(0,num_easy+num_med-1)])
			
			recipe = get_random_array(1,bases)
			#now mix up order of ingredients and operations
			var recipe_suffix= []
			#random ingredients
			var rand_ingred = get_random_array(rng.randi_range(3,4),ingredients)
			recipe_suffix.append_array(rand_ingred)
			
			#operations
			var rand_op = get_random_array(rng.randi_range(2,3),operations)
			recipe_suffix.append_array(rand_op)
			
			recipe_suffix.shuffle()
			
			recipe.append_array(recipe_suffix)
			
		potions_recipes[potion] = recipe
		#change mode
		if potions_recipes.keys().size() == num_easy:
			dif=mode.MED
		elif potions_recipes.keys().size() == (num_easy+num_med):
			dif=mode.HARD
			
	#should return an
	return potions_recipes
	
# take num amount of random non unqiue items from the given arr
# returns the new randomized array with size num.
func get_random_array(num: int,arr: Array):
	var rand_ingreds =[]
	for i in range(num):
		rand_ingreds.append(arr[rng.randi() % arr.size()])
	return rand_ingreds
	
	
