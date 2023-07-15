class_name LootTable
extends Resource

@export var entries: Array[LootTableEntry] = []

var _weights = []
var _total = 0.0

func pick_weighted() -> Item:
	if _total < 1.0:
		entries.sort_custom(_compare_entries)
		_weights.resize(entries.size())

		for i in range(entries.size()):
			_weights[i] = entries[i].weight + _total
			_total += entries[i].weight
	var r = randf() * _total
	return entries[_weights.bsearch(r, true)].item


func _compare_entries(a: LootTableEntry, b: LootTableEntry) -> bool:
	return b.weight > a.weight
