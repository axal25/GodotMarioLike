extends Node

const SAVE_PATH = "res://savegame.bin" # "users://savegame.bin"

func saveGame():
	var dataDict: Dictionary = Game.state.getDictionary()
	var dataJson = JSON.stringify(dataDict)
	writeToFile(dataJson)

func writeToFile(input: String):
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_line(input)

func loadGame():
	var dataDict = readFileToDictionary(SAVE_PATH)
	Game.state = Game.State.parseDictionary(dataDict)

func readFileToDictionary(filePath: String):
	if not FileAccess.file_exists(filePath):
		return null
	
	var file = FileAccess.open(filePath, FileAccess.READ)
	var fileString = ""
	while not file.eof_reached():
		var line = file.get_line()
		fileString += line
	return JSON.parse_string(fileString)
