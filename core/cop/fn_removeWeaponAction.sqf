/*---------------------------------------------------------------------------
	Author Scotty from Realmenofgenius // Tweaked for LifeStudios by Oscar Rogain
	11/01/2015
---------------------------------------------------------------------------*/

private["_hgItems","_holder","_items","_pwItems","_safeItems","_swItems","_weps"];

_safeItems = ["FirstAidKit","ItemRadio","ItemMap","ItemCompass","ItemGPS","ItemWatch","NVGoggles","Binocular"];



0 cutText["You've been searched, and all of your weapons were placed on the floor infront of you.","PLAIN"];

//--Get weapons, attachments and magazines of player
_weps = [];

_pwItems = primaryWeaponItems player;
_swItems = secondaryWeaponItems player;
_hgitems = handGunItems player;

_mags = magazinesAmmoFull player;

//--Now remove stuff

{player removeMagazine _x} foreach (magazines player);

if(primaryWeapon player != "") then
{
	_weps pushBack (primaryWeapon player);
	player removeWeapon (primaryWeapon player);

};
		
if(secondaryWeapon player != "") then
{
	_weps pushBack (secondaryWeapon player);
	player removeWeapon (secondaryWeapon player);

};
		
if(handgunWeapon player != "") then
{
	_weps pushBack (handgunWeapon player);
	player removeWeapon (handgunWeapon player);
};

{
	_items = _x;
	{
		player unassignItem _x;
		player removeItem _x;
	}forEach _items;
	
}forEach [_hgItems, _pwItems, _swItems];

//--Anything in backpack, vest etc we forgot? Make sure we don't include rangefinders etc. 

{
	if (!(_x in _safeItems)) then
	{
		player removeItem _x;
		_weps pushBack _x;
	};

}forEach (weapons player);


//-- Create holder and add everything to it.
 _holder = createVehicle [ "GroundWeaponHolder", getPosATL player, [], 0, "CAN_COLLIDE" ];
 
{
	_holder addWeaponCargoGlobal [_x,1];
}forEach _weps;

{
	_holder addMagazineCargoGlobal [_x select 0,1];
}forEach _mags;

{
	_items = _x;
	{
		_holder addItemCargoGlobal [_x,1];
	}forEach _items;
}forEach [_hgItems, _pwItems, _swItems];

player say3D "Patdown";
//--Save the player's updated gear.
[3] spawn SOCK_fnc_updatePartial;