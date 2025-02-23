extends Node


var sus_sources = {}


func sus_source(weight : int, pos : Vector3):
	if sus_sources.has(weight):
		(sus_sources[weight] as PoolVector3Array).append(pos)
	else:
		sus_sources[weight] = [pos]

