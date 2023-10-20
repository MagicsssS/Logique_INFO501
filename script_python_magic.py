from unidecode import unidecode #Some Random Librairies I Found On Github

#Right here in fact : https://stackoverflow.com/questions/517923/what-is-the-best-way-to-remove-accents-normalize-in-a-python-unicode-string

def magic():
	enorme_string = ""

	with open("misty.pl", "r", encoding="utf-8") as f:
		lines = f.readlines()

	for line in lines:
		print("Printing some magic for my dear github followers")
		#Casting a spell right here :
		enorme_string+=unidecode(line)

	with open("misty_magic.pl", "w", encoding="utf-8") as f:
		f.write(enorme_string)

magic()