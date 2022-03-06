extends Label

func update_text(level, experience, required_exp):
#	text = """Level: %s
#			Experience: %s
#			Next Level: %s
#			""" % [level, experience, required_exp]
	text = """ LV : %s           ( %s / %s )""" % [level, experience, required_exp]
	

