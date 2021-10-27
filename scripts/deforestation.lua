local deforestation = ...

--self-destruct component
-------------------------------------
local COMP_SELF_DESTRUCT = {
	TypeName = "COMP_SELF_DESTRUCT",
	ParentType = "COMPONENT"
}

function COMP_SELF_DESTRUCT:update()
	self:getOwner():getParent():destroy()
end

deforestation:registerClass(COMP_SELF_DESTRUCT)


--register prefabs and their components
-----------------------------------------------------------------------
local parts = {
	["TINY_DEFORESTATION_PART"] = {
		["path"] = "models/Deforestation1.fbx/Prefab/tiny_deforestation_part",
		["size"] = 1
	},
	["SMALL_DEFORESTATION_PART"] = {
		["path"] = "models/Deforestation1.fbx/Prefab/small_deforestation_part",
		["size"] = 12.5
	},
	["MEDIUM_DEFORESTATION_PART"] = {
		["path"] = "models/Deforestation1.fbx/Prefab/medium_deforestation_part",
		["size"] = 25
	},
	["LARGE_DEFORESTATION_PART"] = {
		["path"] = "models/Deforestation1.fbx/Prefab/large_deforestation_part",
		["size"] = 50
	},
	["PATH_DEFORESTATION_PART"] = {
		["path"] = "models/Deforestation1.fbx/Prefab/path_deforestation_part",
		["size"] = { 25.0, 5.0 }
	}
}

for key, value in pairs(parts) do
    deforestation:registerAssetId(value["path"],"PREFAB_"..key)
	deforestation:registerPrefabComponent(value["path"], {
		DataType = "COMP_SELF_DESTRUCT"
	})
	deforestation:registerPrefabComponent(value["path"], {
		DataType = "COMP_BUILDING_PART"
	})
	deforestation:registerPrefabComponent(value["path"], {
		DataType = "COMP_GROUNDED",
        SetOrientation = true,
	})
end


--register assets
---------------------------------------------------------------------
for key, value in pairs(parts) do

    local myPolygon = nil

    if string.match(key, "PATH") ~= nil then
        myPolygon = polygon.createRectangle(value["size"],{0,0})
    else
        myPolygon = polygon.createCircle(value["size"],{0,0},6)
    end

	deforestation:register({
		DataType = "BUILDING_PART",
		Id = key,
		Name = key.."_NAME",
		Description = key.."_DESC",
		Category = "CORE",
		ConstructorData = {
			DataType = "BUILDING_CONSTRUCTOR_DEFAULT",
			CoreObjectPrefab = "PREFAB_"..key,
            MiniatureConfig = {
                ClipUnderGround = true,
                GroupHeight = 0.0,
                CameraPosition = { 0, 0, 0 },
                OrientationOffset = 0,
                CameraPitchOffset = 25.0
            },
        },
		BuildingZone = {
			ZoneEntryList = {
				{
					Polygon = myPolygon,
					Type = {
						DEFAULT = true,
						NAVIGABLE = true,
						GRASS_CLEAR = false
					}
				}
			}
		}
	})
end

--polygon.createCircle(value["size"],{0,0},6),

deforestation:register({
    DataType = "BUILDING_PART",
    Id = "ICON_PART",
    ConstructorData = {
    DataType = "BUILDING_CONSTRUCTOR_DEFAULT",
    CoreObjectPrefab = "PREFAB_TREE_PINE"
    }
})

deforestation:register({
	DataType = "BUILDING",
	Id = "FE_MONUMENT_DEFORESTATION",
	Name = "DEFORESTATION_MONUMENT_NAME",
	Description = "DEFORESTATION_MONUMENT_DESC",
	BuildingType = "MODS",
	AssetCoreBuildingPart = "BUILDING_PART_MONUMENT_POLE",
    AssetMiniatureBuildingPart = "ICON_PART",
	BuildingPartSetList = {
		{
			Name = "LIST_DEFORESTATION_NAME",
	        BuildingPartList = {
				"TINY_DEFORESTATION_PART",
				"SMALL_DEFORESTATION_PART",
				"MEDIUM_DEFORESTATION_PART",
				"LARGE_DEFORESTATION_PART",
				"PATH_DEFORESTATION_PART"
			}
		}
    },
	IsClearTrees = true
})