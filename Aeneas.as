// Name: Aeneas.as
// Author(s):
// version 0.1
// --------------------------------------
// This module controls Aeneas the character
// and includes his inventory etc.

#include "include/ControllableChar.as"
// #include "include/Inventory.as"  <-- might add this in the future
// #include "include/Weapon.as"

void initialize () {
	// Retrieve data from the save files and figure out what to do from there
	boolean thereIsASaveGame = false; // Change this
	if( thereIsASaveGame ) {
		// Then retrieve the ControllableChar object saved
	} else {
		ControllableChar aeneas = new ControllableChar();
		// Place Aeneas at the correct position on the map via updatePos;
	}

	// Finish this
}

// ----------------------------------------------------------------------------------------------------------------------

void step ( uint16 milliseconds ) {
	// Update health, stamina, piety points
	// Update position
	// Update directionality
	// Update state (attack, walking, etc.)
	// Update animation
	// Update armor, weapons
	// Interact with picking up weapons

	aeneas.setRotation();
	aeneas.checkInputs();
}