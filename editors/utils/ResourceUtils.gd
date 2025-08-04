extends Node

class_name ResourceUtils

static func load_resources_from_folder(folder_path: String, resource_type: String) -> Array:
	var results: Array = []
	var dir := DirAccess.open(folder_path)

	if dir == null:
		push_error("Pasta não encontrada: " + folder_path)
		return results

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres") or file_name.ends_with(".res"):
			var res_path = folder_path.path_join(file_name)
			var resource = load(res_path)
			if resource and resource is GDWeaponData or EquipmentData:
				results.append(resource)
			else:
				print("⚠️ Ignorando (tipo diferente): ", res_path, " [tipo: ", resource.get_class(), "]")
		file_name = dir.get_next()
	dir.list_dir_end()

	return results
