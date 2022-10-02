extends Node2D

class_name RecipeGenerator

enum op {WATER, 
HEAT_SHORT, HEAT_MED, HEAT_LONG, COOL, SHAKE,
PLANT, LIZARD, CRYSTAL, EYEBALL, MUSHROOM,
GROUND_PLANT, GROUND_LIZARD, GROUND_CRYSTAL, GROUND_EYEBALL, GROUND_MUSHROOM}

enum potions {HEALTH, SPEED, INVISIBLE, POWER, WATER,
SUPER_SONIC, JOE_TOES, JIM, JOM, TOM}

enum mode {EASY, MED, HARD}

var ingredients= op.values().slice(op.PLANT, op.keys().size()-1)
var operations= op.values().slice(op.HEAT_SHORT, op.SHAKE) #same operation can't be together
#long heat for complex 
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
			# add ground to easy
			
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
			var rand_ingred = get_random_array(rng.randi_range(2,3),ingredients)
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

#randomly merge ingredients with no negiboring ops being the same
func random_ops_ingreds(ingred: Array, op_arr:Array, max_ingred: int, max_op: int):
	var merged_arr = []
	var cur_ingred = 0
	var cur_op = 0
	var ingred_op_choice = 0
	#rng.randomize()
	
	for i in range(max_ingred+max_op):
		#chose to add ingred 0 or op_arr 1 if either full
		if cur_ingred == max_ingred && cur_op<max_op:
			ingred_op_choice=1
		elif cur_op == max_op && cur_ingred<max_ingred:
			ingred_op_choice=0
		else:
			ingred_op_choice = (rng.randi() % 2)
			
		if ingred_op_choice == 0 && cur_ingred<max_ingred:
			merged_arr.append(ingred[rng.randi() % ingred.size()])
			cur_ingred+=1
		elif ingred_op_choice == 1 && cur_op<max_op:
			#check if prevoius item is not the same operation
			# cant have two heats in a row\
			var last_item = merged_arr.back()
			var heat_ops = [op.HEAT_LONG, op.HEAT_MED, op.HEAT_SHORT]
			var new_op =null
			var valid_op= false
			
			#keep random gen until finding valid op
			while !valid_op:
				new_op = op_arr[rng.randi() % op_arr.size()]
				
				#retry if both heat items
				if heat_ops.has(last_item) && heat_ops.has(new_op):
					continue
				elif last_item != new_op:
					valid_op=true
				
			merged_arr.append(new_op)
			cur_op+=1
		
	
	return merged_arr
	
	
	
	
