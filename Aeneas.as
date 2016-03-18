// Name: Aeneas.as
// Author(s):
// version 0.1
// --------------------------------------
// This module controls Aeneas the character
// and includes his inventory etc.

#include "include/ControllableChar.as"
// #include "include/Inventory.as"  <-- might add this in the future
// #include "include/Weapon.as"

import array< AIChar > @ getTrojans() from "TrojanGreek.as";
import array< AIChar > @ getGreeks() from "TrojanGreek.as";

const float BASE_WALK_SPEED = 300;
ControllableChar aeneas;

void initialize () {
	int x;
		if( ee::readFromDataCont( "Aeneas", "cHealth", x ))
		 	finishInitialization( true ); 
			else
		finishInitialization( false );
}

void finishInitialization ( bool thereIsASaveGame ) {
	if( thereIsASaveGame ) {
		int cHealth, mHealth, x, y;
		float walkSpeed, carryWeight, maxCarryWeight;
		double angle;
  
		ee::readFromDataCont( "Aeneas", "cHealth", cHealth);
		ee::readFromDataCont( "Aeneas", "mHealth", mHealth);
		ee::readFromDataCont( "Aeneas", "walkSpeed", walkSpeed);
		ee::readFromDataCont( "Aeneas", "piety", piety);
		ee::readFromDataCont( "Aeneas", "carryWeight", carryWeight);
		ee::readFromDataCont( "Aeneas", "maxCarryWeight", maxCarryWeight);

		ee::readFromDataCont( "Aeneas", "x", x);
		ee::readFromDataCont( "Aeneas", "y", y);
		ee::readFromDataCont( "Aeneas", "angle", angle);
	} else {
		aeneas = ControllableChar( "Character", "Aeneas", Inventory(), 0, 0, 0, 100, 100, BASE_WALK_SPEED, 0, 0.0, 50.0, 0 );
		// Place Aeneas at the correct position on the map via updatePos;
	}
	aeneas.setTrojans( getTrojans() );
	aeneas.setGreeks( getGreeks() );
}

bool requestSaveData () {
	try {
		return aeneas.saveRequestValues();
	} catch { 
		ee::consolePrintln( "ERROR: Aeneas.requestSaveData cannot save Aeneas." );
		return false;
	}
}

// function to transfer Aeneas to another module
ControllableChar @ getAeneas() { return aeneas; }

// function to transfer Aeneas' position to another module
CharPosition @ getAeneasPos() { return aeneas.getCharPosition(); }

float getAeneasWalkSpeed() { return aeneas.getStat().getWalkSpeedRef(); }


// ----------------------------------------------------------------------------------------------------------------------

void step ( uint32 milliseconds ) {
	// Update health, stamina, piety points
	// Update position
	// Update directionality
	// Update state (attack, walking, etc.)
	// Update animation
	// Update armor, weapons
	// Interact with picking up weapons

	aeneas.setRotation();
	aeneas.checkInputs( milliseconds );

}
	
