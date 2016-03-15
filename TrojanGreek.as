// Name: Aeneas.as
// Author(s): Jason Wang, Rene Lee
// version 0.1
// --------------------------------------
// This module sets up the Trojans and Greeks

#include "include/AIChar.as";

array<AIChar> trojans; // Array of Trojans
array<AIChar> greek; // Array of Greeks

void initialize() {
    // Check savestate for previously saved stuff
    if( !( requestTrojans() && requestGreeks() ) ) {
        // Set up trojans and greeks for the first time, in the first map
    }
}

void step( uint32 milliseconds ) {
    for( AIChar trojan: trojans ) {
    	trojan.step( milliseconds );
    }
    for( AIChar greek: greeks ) {
    	greek.step( milliseconds );
    }
}

bool saveAIChars() {
	try {
		int count = 0;
		for( AIChar trojan: trojans ) {
			trojan.requestSaveData( "trojan", count );
			count++;
			ee::writeToDataCont( "trojanNumber", "number", count );
		}
		count = 0;
		for( AIChar greek: greeks ) {
			greek.requestSaveData( "greek", count );
			count++;
			ee::writeToDataCont( "greekNumber", "number", count );
		}
		return true;
	} catch { 
		ee::consolePrintln( "ERROR: TrojanGreek.saveAIChars does not work." );
		return false;
	}
}

// Loads Trojans
bool requestTrojans() {
	try {
		int n = ee::readFromDataCont( "trojanNumber", "number" );
		for( int i = n; i >= 0; i-- ) {
			// Logic to get all the parameter / values from each trojan

			int cHealth = ee::readFromDataCont( "trojan" + i, "cHealth" );
			int mHealth = ee::readFromDataCont( "trojan" + i, "mHealth" );
			float walkSpeed = ee::readFromDataCont( "trojan" + i, "walkSpeed" );
			float rotationSpeed = ee::readFromDataCont( "trojan" + i, "rotationSpeed" );
			bool invincibility = ee::readFromDataCont( "trojan" + i, "invincibility" );
			bool isItHostile = ee::readFromDataCont( "trojan" + i, "isItHostile" );

			int x = ee::readFromDataCont( "trojan" + i, "x" );
			int y = ee::readFromDataCont( "trojan" + i, "y" );
			double angle = ee::readFromDataCont( "trojan" + i, "angle" );

			AIChar aic = AIChar( x, y, angle, cHealth, mHealth, walkSpeed, 
					rotationSpeed, invincibility, isItHostile );

			trojans.add( aic );

			return true;
		}
	} catch {
		ee::consolePrintln( "ERROR: TrojanGreek.requestTrojans does not work." );
		return false;
	}
}

// Loads Greeks
bool requestGreeks() {
	array<string> keys;
	try {
		int n = ee::readFromDataCont( "greekNumber", "number" );
		for( int i = n; i >= 0; i-- ) {
			// Logic to get all the parameter / values from each trojan

			int cHealth = ee::readFromDataCont( "greek" + i, "cHealth" );
			int mHealth = ee::readFromDataCont( "greek" + i, "mHealth" );
			float walkSpeed = ee::readFromDataCont( "greek" + i, "walkSpeed" );
			float rotationSpeed = ee::readFromDataCont( "greek" + i, "rotationSpeed" );
			bool invincibility = ee::readFromDataCont( "greek" + i, "invincibility" );
			bool isItHostile = ee::readFromDataCont( "greek" + i, "isItHostile" );

			int x = ee::readFromDataCont( "greek" + i, "x" );
			int y = ee::readFromDataCont( "greek" + i, "y" );
			double angle = ee::readFromDataCont( "greek" + i, "angle" );

			AIChar aic = AIChar( x, y, angle, cHealth, mHealth, walkSpeed, 
					rotationSpeed, invincibility, isItHostile );

			greeks.add( aic );
			return true;
		}
	} catch {
		ee::consolePrintln( "ERROR: TrojanGreek.requestGreeks does not work." );
		return false;
	}
}