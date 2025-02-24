extends Spatial
class_name PeopleHolder

var stored_people

func TransferPeople(Target):
	Target.stored_people = stored_people
	if Target == null:
		print("error Target is null")
		get_tree().quit()
	Target.stored_people.global_transform.origin = Target.get_global_transform().origin ## Target.stored_people is returning null meaning either Target or stored_people is null
	stored_people = null## Target.stored_people is null, likelye from back from toilet function
	DoStuffAfterTransfer()
	
func DoStuffAfterTransfer():
	pass
