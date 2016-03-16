// Name: AIChar.as
// Author(s): Jason Wang
// version 0.1
// --------------------------------------
// This class is designed to be an NPC 
// that is AI controlled (like followers
// or enemies)

#include "Character.as"
#include "Weapon.as"

class AIChar : Character
{
	final static float PI = 3.14159;
	CharPosition @ pos;
	CharStats @ stats;

	AIChar() {
		Character();

		pos = getPos(); 
		stats = getStat();
	}

	// Constructor with all values as parameter
	AIChar( int x, int y, double angle, int cH, int mH, float wS, float rS, bool immunity, bool hostile ) {
		Character( x, y, angle, cH, mH, wS, rS, immunity, hostile );

		pos = getPos(); 
		stats = getStat();
	}

	void follow ( Character aic, uint32 milliseconds )
	{
		//Andrew made a new inRange function below this that does same function as this whole comment
		
		/* CharPosition@ rPos = aic.getPos();

		int yDif = pos.getY() - rPos.getY();
		int xDif = pos.getX() - rPos.getX();

		double angle = 180 / PI * atan( ( float(yDif) ) / xDif ); 
		if( xDif < 0 ) {
			pos.setAngle(pos.getAngle() + 180);
		}


		float distance = sqrt( yDif*yDif + xDif*xDif ); 
		float bubble = 30; //or 20

		updatePos( pos.getX(), pos.getY(), pos.getAngle() );

		// NOTE: Changed this so that it actually moves DIRECTLY towards AIChar being followed
		// with the correct speeds (using cos and sin) */
		if(inRange(aic))
		{
			/*
			updatePos( pos.x + stats.walkSpeed * milliseconds / 1000, 
					pos.y + stats.walkSpeed * milliseconds / 1000, pos.getAngle() );
			*/
			x = pos.getX() + stats.getWalkSpeed() * milliseconds / 1000 * cos( PI / 1000 * angle );
			y = pos.getY() + stats.getWalkSpeed() * milliseconds / 1000 * sin( PI / 1000 * angle );
			updatePos( x, y, angle );
		}
		else
			updatePos( pos.getX(), pos.getY(), pos.getAngle() );

	}
	
	bool inRange(Character aic)
	{
		CharPosition@ rPos = aic.getPos();

		int yDif = pos.getY() - rPos.getY();
		int xDif = pos.getX() - rPos.getX();

		float distance = sqrt( yDif*yDif + xDif*xDif ); 
		float bubble = 30; 
		
		if( bubble > distance )
		return false;
		else
		return true;
	}
	
	bool inRangeToAttack(Character aic)
	{
	 CharPosition@ rPos = aic.getPos();

		int yDif = pos.getY() - rPos.getY();
		int xDif = pos.getX() - rPos.getX();

		float distance = sqrt( yDif*yDif + xDif*xDif ); 
		float bubble = 5; 
		
		if( bubble > distance )
		return false;
		else
		return true;
	}

	void updatePos( int iX, int iY, double ang )
	{
		// ee::consolePrintln( "Updates the position and angle of the character." );
		pos.setX(iX);
		pos.setY(iY);
		pos.setAngle(ang);
		
	}

	void rotate ( uint32 milliseconds )
	{
		// ee::consolePrintln( "Rotates angle of the character" );
		pos.angle += stats.rotationSpeed / 1000 * milliseconds; 
	}

	const CharPosition@ getPos()
	{
		// ee::consolePrintln( "Returns the position of the character." );
		CharPosition@ refPos = pos;

		if (refPos != null )
		{
			return refPos;
		}
		ee::consolePrintln( "ERROR: CharPosition of AIChar is null.");
		return CharPosition( 0, 0, 0 );
	}

	//Randomly moves when Aeneas is not around. When Aeneas is within a certain range, will begin to follow and attack 
	//WORK IN PROGRESS
	void move(uint16 milliseconds)
	{	
		// NOTE: Allow for gradual angle changes as well
		updatePos( cos( pos.getAngle() * PI / 180 ) * milliseconds * stats.getWalkSpeed() / 1000, 
			   sin( pos.getAngle() * PI / 180 ) * milliseconds * stats.getWalkSpeed() / 1000, 
			   pos.getAngle() ); 
		
	}

	//Please Check this method for me! -Rene Lee
	// Checked -Jason Wang
	void attack(AIChar npc) //shouldn't it pass in nothing? (unless "int damage" is how much damage the enemy does) -Andrew
	{
		int damage = stats.getDamage();
		// DO THE attack animation
		npc.changeHealth( damage );
				
	}

	void talk( string phrase )
	{	
		// make text appear on screen
		ee::AnimatedEntity text = ee::AnimatedEntity(); //errors here (talk to dennis)
		addEntitytoRender(0,text,n); //n not declared
		
	}

	void changeHealth( int difference )
	{
		if( stats.isInvincible ) 
			return;
		stats.damage( difference ); 
		if(stats.getCHealth <= 0)
		{
			// change image to dead body and kill NPC
		}
	}
	
	// Complex af and confusing to me -Jason Wang
	// TODO: Please make this either clearer or better. IDK which
	void fighting(Character npc, uint32 milliseconds)
	{
		if(!inRange(npc))
			return;
		
		follow(npc, milliseconds);
		/*int nx = npc.CharPosition().x;
		int ny = npc.CharPosition().y;
		int cx = CharPosition().x;
		int cy = CharPosition().y;
		int angle;
		
		if(cx-ny <= 0 && cy-ny <= 0) //lines 12-22 is setting position to face enemy
			{
				angle = 180 + int(atan(abs(cy-ny),abs(cx-nx)));
				setPosition(angle);
			}
		else if(cx-nx<=0 && cy-ny>=0)	
		{
			angle = 90 + int(atan(abs(cy-ny),abs(cx-nx))); 
			setPosition(angle); //can divide angle by 10 or something so that it doesnt turn instantaneously or use MOVE FUNCTION
		}
		else{setRotation(int(atan(abs(cy-ny),abs(cx-nx))));} */
		
		//shouldn't be exacty 180 since comparing doubles
		if( abs( pos.angle - npc.pos.angle )<181 && abs( pos.angle - npc.pos.angle ) > 179  && inRangeToAttack(npc) )
			attack(npc); 
	}

	bool isHostile()
	{
		return stats.isHostile();
	}

	// Put step logic in here.
	void step( uint32 milliseconds ) {
		// Fight with nearest individual (follow to individual, attack him)
		// If Aeneas comes within a certain distance, follow Aeneas and attack him.
			// All AIChar are invincible UNTIL they engage in combat with Aeneas.
			// This is done to prevent AIChar from dying before Aeneas comes.
			// Essentially, if this is not done, AI will die before Aeneas even
			// reaches them.

		// IF THERE IS TIME:
			// Figure out a way to make friendly AI (Trojans) talk when clicked upon
				// This is partially done in ControllableChar class already
			// Maybe have some random Trojan "gangs" wandering around
	}

	void requestSaveData( string prefix, int i ) {
		ee::writeToDataCont( prefix + i, "cHealth", stats.getCHealth() );
		ee::writeToDataCont( prefix + i, "mHealth", stats.getMHealth() );
		ee::writeToDataCont( prefix + i, "walkSpeed", stats.getWalkSpeed() );
		ee::writeToDataCont( prefix + i, "rotationSpeed", stats.getRotationSpeed() );
		ee::writeToDataCont( prefix + i, "invincibility", stats.isInvincible() );
		ee::writeToDataCont( prefix + i, "isItHostile", stats.isHostile() );
		ee::writeToDataCont( prefix + i, "damage", stats.getDamage() );

		ee::writeToDataCont( prefix + i, "x", pos.x );
		ee::writeToDataCont( prefix + i, "y", pos.y );
		ee::writeToDataCont( prefix + i, "angle", pos.angle );
	}
}

class Action
{
	/*
	string movement;
	int degree;
	
	Action( string m, int d ) {
		// ee::consolePrintln( actionName + " is being executed." );
		movement = m;
		degree = d;
	}
	*/
	string actionName;

	Action( string aN ) {
		actionName = aN;
	}

}