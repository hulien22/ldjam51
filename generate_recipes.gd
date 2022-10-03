extends Node2D

class_name RecipeGenerator

enum op {WATER = 0,
HEAT_SHORT=1, HEAT_MED, HEAT_LONG, SHAKE,
PLANT=10, LIZARD, CRYSTAL, EYEBALL, MUSHROOM,
GROUND_PLANT=20, GROUND_LIZARD, GROUND_CRYSTAL, GROUND_EYEBALL, GROUND_MUSHROOM,
EMPTY_BOTTLE=100, WATER_BOTTLE, POTION, REQUEST}

enum potions {HEALTH, SPEED, INVISIBLE, POWER, DANCE,
SHRINK, SHINE, LOVE, SWIFT, FIRE}

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

#generates recipe with hardcoded recipes
#returns dict of RECIPEGENERATOR.potions as keys and RECIPEGENERATOR.op as values
func generate_recipe_template():
	#easy
	potions_recipes[potions.HEALTH]= [op.WATER,rnd_ingred(),op.HEAT_MED,op.SHAKE]
	potions_recipes[potions.SPEED]= [op.WATER,rnd_ingred(),rnd_ingred(),op.HEAT_SHORT]
	potions_recipes[potions.INVISIBLE]= [op.WATER,rnd_ingred(),op.SHAKE,rnd_ingred()]
	#medium
	potions_recipes[potions.POWER]= potions_recipes[potions.HEALTH] + [op.HEAT_MED,rnd_ingred(),op.SHAKE]
	potions_recipes[potions.DANCE]= [op.WATER,rnd_ingred(),op.HEAT_LONG,rnd_ingred(),op.SHAKE,op.HEAT_SHORT]
	potions_recipes[potions.SHRINK]= potions_recipes[potions.SPEED] + [op.SHAKE,rnd_ingred()]
	#hard
	potions_recipes[potions.SHINE]= [op.WATER,rnd_ingred(),op.SHAKE,rnd_ingred(),op.SHAKE,rnd_ingred(),op.SHAKE,op.HEAT_LONG]
	potions_recipes[potions.SWIFT]= potions_recipes[potions.POWER]+ [rnd_ingred()]
	potions_recipes[potions.LOVE]= potions_recipes[potions.SHRINK]+ [op.HEAT_SHORT,rnd_ingred(),op.HEAT_MED]
	#final
	potions_recipes[potions.FIRE]= [op.WATER,rnd_ingred(),rnd_ingred(),op.HEAT_SHORT,rnd_ingred(),op.SHAKE,op.HEAT_LONG,rnd_ingred(),rnd_ingred(),op.SHAKE, rnd_ingred()]
	
	return potions_recipes

# generate num_easy+num_med+num_hard recipes
#returns dict of RECIPEGENERATOR.potions as keys and RECIPEGENERATOR.op as values
func generate_recipes_random(num_easy, num_med, num_hard):
	
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
		var op_ingred_arr= []
		#generate length (based on mode)
		if dif==mode.EASY:
			
			#base
			recipe = [op.WATER]
			op_ingred_arr = random_ops_ingreds(rng.randi_range(1,2),rng.randi_range(0,1))
			
			
		elif dif==mode.MED:
			#base
			var bases= [potions_recipes.keys().slice(0,num_easy-1)]
			#chose a base
			var base = bases[rng.randi() % bases.size()]
			#add to recipe
			recipe = potions_recipes[base]
			#now mix up order of ingredients and operations
			op_ingred_arr = random_ops_ingreds(rng.randi_range(2,3),rng.randi_range(1,2))
			
		else:
			#base (can be water or previous 
			var bases= [potions_recipes.keys().slice(0,num_easy+num_med-1)]
			#chose a base
			var base = bases[rng.randi() % bases.size()]
			#add to recipe
			recipe = potions_recipes[base]
			#now mix up order of ingredients and operations
			op_ingred_arr = random_ops_ingreds(rng.randi_range(3,4),rng.randi_range(2,3))
		
		recipe.append_array(op_ingred_arr)
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
	
func rnd_ingred():
	return ingredients[rng.randi() % ingredients.size()]

#randomly merge ingredients with no negiboring ops being the same
func random_ops_ingreds(max_ingred: int, max_op: int):
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
			merged_arr.append(ingredients[rng.randi() % ingredients.size()])
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
				new_op = operations[rng.randi() % operations.size()]
				
				#retry if both heat items
				if heat_ops.has(last_item) && heat_ops.has(new_op):
					continue
				elif last_item != new_op:
					valid_op=true
				
			merged_arr.append(new_op)
			cur_op+=1
		
	
	return merged_arr
	
	
func get_color_from_recipe(recipe: Array):
	match recipe:
		[]: return '00000000'
		[RECIPEGENERATOR.op.WATER]: return '01c6cb'
		_: pass
	var recipe_string = ""
	for i in recipe:
		recipe_string += str(i)
	var my_hash_int = recipe_string.sha256_text().hash() | 0x000000ff
	return my_hash_int
	
