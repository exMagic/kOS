
RUNONCEPATH("0:/boot/kOS/Starship/trajectory.ks").
RUNONCEPATH("0:/boot/kOS/Starship/functions.ks").
RUNONCEPATH("0:/boot/kOS/Starship/steps.ks").


global isDryTest is false.
local targetAltitude is 10000.
global stableSeconds is 0.

global myYAW is 0.
global AngVelToNorth is 0.
global AngPadToNorth is 0.

global _Pich is 0.
global AngVelToUp is 0.
global AngPadToUp is 0.
global frt is 0.
global frt0 is 0.

global logfile is "Log" + RANDOM() + ".csv".

global _is is 0.
global c is 0.
global a1 is 0.
global d1 is 0.


global _lng is 0.
global _alt is 0.

global AltError is 0.
global AltError2 is 0.

global TLFIndex    is 1.
global TRFIndex    is 0.
global BLFIndex    is 2.
global BRFIndex    is 3.

global ForeAngle is 0.
global StarAngle is 0.
global TopAngle is 0.

global Va is V(0,0,0).
global Vb is V(0,0,0).

global StarToVelAngle is 0.
global ForeToVelAngle is 0.
global UPToVelAngle is 0.

global StarNorthAngle is 0.
global ForeAngleToVel is 0.

global pichSpeed is 0.

global RollDiff is 0.
global RollSpeed is 0.
global RollOffset is 0.
// global RightOffset is 0.
// global LeftOffset is 0.
global RollBreakMultiFactor is 0.
global RollReactionMultiFactor is 0.
global YawDiff is 0.
global YawSpeed is 0.
global YawOffset is 0.

global padLAT is -0.09721.
global PadLNG is -74.55766.
global LATSpeed is 0.
global LATDiff is 0.
global PichNavCorrection is 0.

global LNGSpeed is 0.
global LNGDiff is 0.
global RollNavCorrection is 0.

global previousPitch is 0.
global previousRoll is 0.
global previousYaw is 0.
global previousLat is 0.
global previousLng is 0.

global TLFAngle is 0.
global TRFAngle is 0.
global BLFAngle is 0.
global BRFAngle is 0.


global TopFlapAngle is 0. 
global BottomFlapAngle is 0.

global MaxFlapAngle is 180.
global MinFlapAngle is 90.
global TopFlapAngleDefoult is 130.
global BottomFlapAngleDefoult is 130.
global TargetForAngle is 66.

global GroundALT is 0.

global StageNo is 0.
global lastCount is 0.
global lastCount2 is 0.
global th is 0.

SET vess to SHIP.
global partlist is vess:PARTSNAMED("hinge.04").

until isDryTest = false{ // Set to TRUE if you want to run dry test on the ground.
    RCS ON.
    GetTelemetry().
    DrawVec().
    SetFlapsVac().  
    printComp(). 
}

/////////////////////////////////////////////////////////////////////////////
////////////////////////////////// STAGES ///////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

//stage.


partlist[BRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//bootom right
partlist[BLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//bottom left
partlist[TRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//top right
partlist[TLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//top left

SET step TO "Orbit".
runstep("Orbit",step_Orbit@).
runstep("Deorbit_burn",step_Deorbit_burn@).
runstep("Descent",step_Descent@).
runstep("Fip_to_up",step_Fip_to_up@).
runstep("Land",step_Land@).




/////////////////////////////////////////////////////////////////////////////
/////////////////////////////// MY FUNCTIONS ////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

function GetTopAngleToUP{
    return VANG(ship:facing:TOPVECTOR,ship:up:vector).
}
function GetStarAngleToUP{
    return VANG(ship:facing:STARVECTOR,ship:up:vector).
}
function GetForeAngleToUP{  
    return VANG(ship:facing:forevector,ship:up:vector).
}
function GetStarAngleToNORTH{  
    return VANG(ship:facing:STARVECTOR,ship:north:vector).
}
function GetForeAngleToVel{  
    return VANG(ship:facing:forevector,SHIP:VELOCITY:SURFACE).
}
//  function GetError{
    
//     set _lng to mylex[_is].
//     set _lng to mylex[_is].
//     set _alt to mylex[_is+1].
    
//     if(SHIP:GEOPOSITION:LNG>_lng){
//         set _is to _is+1.
//         set AltError to _alt - SHIP:ALTITUDE.
//     }
// }
 function SetAltError{
    if (_is<mylist:length){
        set _lng to mylist[_is].
        set _alt to mylist[_is+1].        
        if(SHIP:GEOPOSITION:LNG+0.12>_lng){
            set _is to _is+2.
            set AltError to  SHIP:ALTITUDE - _alt.
        }
    }
}

 function derr{
    // set c to sqrt((LNGDiff*LNGDiff)+(LATDiff*LATDiff)).
    // set a1 to 45 * (abs(LATDiff)/abs(LNGDiff))-d1.
    
    set AngVelToNorth to VANG(SHIP:VELOCITY:surface,ship:north:vector).

    if (LATDiff<0){
        set AngPadToNorth to 90 + (45 * (abs(LATDiff)/abs(LNGDiff))).
    }else{
        set AngPadToNorth to 90 - (45 * (abs(LATDiff)/abs(LNGDiff))).
    }

    

}



function GetTelemetry{

    set GroundALT to ship:altitude-SHIP:GEOPOSITION:TERRAINHEIGHT.

    set LATDiff to padLAT - SHIP:GEOPOSITION:LAT.
    set LNGDiff to PadLNG - 0.001 - SHIP:GEOPOSITION:LNG.
    set TargetVector to SHIP:UP:vector + R(0,(VANG(SHIP:VELOCITY:surface, SHIP:up:vector)-70) * -1,0).


    


    if (time:seconds-lastCount>0.1){
        set lastCount to  time:seconds.

        // LATSpeed
        set newLat to SHIP:GEOPOSITION:LAT.
        set LATSpeed to (previousLat - newLat).
        set previousLat to newLat.  
        
        // LNGSpeed
        set newLng to SHIP:GEOPOSITION:LNG.
        set LNGSpeed to (previousLng - newLng).
        set previousLng to newLng.  

        // PICH SPEED
        set newPitch to ForeAngle.
        set pichSpeed to (previousPitch - newPitch) * -1.
        set previousPitch to newPitch.  
        // ROLL SPEED
        set newRoll to StarAngle.
        set RollSpeed to (previousRoll - newRoll) * -1.
        set previousRoll to newRoll.  
        // YAW SPEED        
        set newYaw to YawDiff.
        set YawSpeed to (previousYaw - newYaw) * -1.
        set previousYaw to newYaw.                             
    }

    set ForeAngle to GetForeAngleToUP().
    set StarAngle to GetStarAngleToUP().
    set TopAngle to GetTopAngleToUP().

    set StarToVelAngle to VANG(SHIP:VELOCITY:surface, SHIP:facing:starvector).
    set ForeToVelAngle to VANG(SHIP:VELOCITY:surface, SHIP:facing:forevector).
    set UpToVelAngle to VANG(SHIP:VELOCITY:orbit, SHIP:facing:upvector).
    
    set StarNorthAngle to GetStarAngleToNORTH().
    set ForeAngleToVel to GetForeAngleToVel().


    if (ship:altitude<70000){
        // if (time:seconds-lastCount2>4){
        //     set lastCount2 to  time:seconds.
        //     LOG SHIP:GEOPOSITION:LNG + ", " + ship:altitude + ", " to logfile.
        // }
        SetAltError().
        //derr().
    }


    set AngVelToNorth to VANG(SHIP:VELOCITY:surface,ship:north:vector).

    if (LATDiff<0){
        set AngPadToNorth to 90 + (45 * (abs(LATDiff)/abs(LNGDiff))).
    }else{
        set AngPadToNorth to 90 - (45 * (abs(LATDiff)/abs(LNGDiff))).
    }

    set AngVelToUp to VANG(SHIP:VELOCITY:surface, SHIP:up:vector).
    set frt0 to 3769911/360 * abs(LNGDiff).
    set frt to  ARCTAN2(ship:altitude,frt0).
    set AngPadToUp to 90 + frt.
    set _Pich to AngPadToUp - AngVelToUp.

}
function SetFlapsVac{

    /////////////////////////////////////////////////////
    // -- PICH
    local PitchReactionMultiFactor is 0.5.
    local PitchBreakMultiFactor is 4.
    
    local limit is 30.
    set AltError2 to MAX(MIN(AltError/15,limit),-limit).        
    
    local ss is 0.
    if (SHIP:altitude<15000){    
        set AltError2 to 0.
    }
    if (SHIP:altitude<10000){    
        set ss to _Pich/2.
    }
    // if (AltError2>20){
    //     set AltError2 to 20.
    // }
    // if (AltError2<-20){
    //     set AltError2 to -20.
    // }

    set TopFlapAngle to TopFlapAngleDefoult - (ForeToVelAngle-(TargetForAngle + AltError2 + ss))* PitchReactionMultiFactor.
    set BottomFlapAngle to BottomFlapAngleDefoult + (ForeToVelAngle-(TargetForAngle + AltError2 + ss))* PitchReactionMultiFactor.
    
    if (TopFlapAngle>MaxFlapAngle){
        set TopFlapAngle to MaxFlapAngle.
    }
    if (TopFlapAngle<MinFlapAngle){
        set TopFlapAngle to MinFlapAngle.
    }
    if (BottomFlapAngle>MaxFlapAngle){
        set BottomFlapAngle to MaxFlapAngle.
    }
    if (BottomFlapAngle<MinFlapAngle){
        set BottomFlapAngle to MinFlapAngle.
    }
    // // -- PichNavCorrection
    // local max is 11.
    // local LATOffset is 0.00462. // Requaire offset of LAT for flipp from horizontal to vertical
    // set PichNavCorrection to (LATDiff + LATOffset) * 3000.
    //     if (PichNavCorrection>max){
    //         set PichNavCorrection to max.
    //     }
    //     if (PichNavCorrection <-max){
    //         set PichNavCorrection to -max.
    // }
    
    /////////////////////////////////////////////////////
    // -- ROLL
    set RollReactionMultiFactor to 0.2.
    set RollBreakMultiFactor to 0.1.   

    set RollDiff to StarToVelAngle -90.
    
    // RollNavCorrection
    // set RollNavCorrection to LNGDiff * 5000 + (LNGSpeed/10).
    // if (RollNavCorrection >11){
    //     set RollNavCorrection to 11.
    // }
    //set RollDiff to RollDiff + RollNavCorrection.
    // if (ship:GROUNDSPEED<300){
    //     set RollOffset to RollDiff * RollReactionMultiFactor + RollSpeed * RollBreakMultiFactor.
    //     // if (RollDiff>0){//lean to left
    //     //     set RightOffset to RollDiff * -1 * RollReactionMultiFactor + RollSpeed * RollBreakMultiFactor.
    //     //     set LeftOffset to RollDiff * RollReactionMultiFactor - RollSpeed * RollBreakMultiFactor.
    //     // }else{//lean to right
    //     //     set LeftOffset to RollDiff * RollReactionMultiFactor - RollSpeed * RollBreakMultiFactor.
    //     //     set RightOffset to RollDiff * -1 * RollReactionMultiFactor + RollSpeed * RollBreakMultiFactor.
    //     // }
    // }else{
    //     set RollOffset to 0.
    // }
    set RollOffset to 0.
    

    /////////////////////////////////////////////////////
    // -- YAW
    local YawReactionMultiFactor is 3.
    local YawBreakMultiFactor is 8.


    if (SHIP:altitude>10000){
        set Va to VCRS(SHIP:VELOCITY:surface, SHIP:up:vector).

        if (ship:GROUNDSPEED<1000){
            if (ForeAngleToVel > 80){
                set TargetForAngle to TargetForAngle-0.2.
            }else{
                set TargetForAngle to TargetForAngle+0.2.
            } 
        }


    }else{
        set Va to ship:north:vector.


        // if (_Pich > 0){
        //     set TargetForAngle to TargetForAngle - _Pich.
        // }else{
        //     set TargetForAngle to TargetForAngle + _Pich.
        // }
    }
    
    
    set Vb to VCRS(SHIP:up:vector,Va).




    if (VANG(ship:facing:starvector,Va)>90){
        set YawDiff to VANG(ship:facing:forevector,Va)-90.            
    }else{
        if (VANG(ship:facing:forevector,Va)<90){
            set YawDiff to (90 + VANG(ship:facing:forevector,Va)) *-1.            
        }else{
            set YawDiff to 180 - (VANG(ship:facing:forevector,Va)-90).            
        }
    }
    
    set myYAW to MIN((AngPadToNorth-AngVelToNorth)*80, 40).

//     // if (SHIP:altitude<15000){
//     if (SHIP:altitude>15000){
//   set Va to VCRS(SHIP:VELOCITY:surface, SHIP:up:vector).
//         set YawDiff to YawDiff - (AngPadToNorth-90).
//     }else{
//         set myYAW to 0.
//     // // }
   

    set YawOffset to YawDiff * YawReactionMultiFactor + YawSpeed * YawBreakMultiFactor - myYAW.// + (d1-a1)/2.// + (LATDiff*10).

    if (YawOffset>30){
        set YawOffset to 30.
    }
    if (YawOffset<-30){
        set YawOffset to -30.
    }



    ///////////////////////////////////////////////////
    ///////////////////////////////////////// SET FLAPS
    ///////////////////////////////////////////////////


    set TLFAngle to TopFlapAngle + PichNavCorrection + RollOffset/2 + pichSpeed * PitchBreakMultiFactor + YawOffset.
    set TRFAngle to TopFlapAngle + PichNavCorrection - RollOffset/2 + pichSpeed * PitchBreakMultiFactor - YawOffset.

    set BLFAngle to BottomFlapAngle + RollOffset - pichSpeed * PitchBreakMultiFactor - YawOffset/5.
    set BRFAngle to BottomFlapAngle - RollOffset - pichSpeed * PitchBreakMultiFactor + YawOffset/5.

    //Limit flaps angle
    if (TLFAngle>MaxFlapAngle){
        set TLFAngle to MaxFlapAngle.
    }else if (TLFAngle<MinFlapAngle){
        set TLFAngle to MinFlapAngle.
    }
    if (TRFAngle>MaxFlapAngle){
        set TRFAngle to MaxFlapAngle.
    }else if (TRFAngle<MinFlapAngle){
        set TRFAngle to MinFlapAngle.
    }
    if (BLFAngle>MaxFlapAngle){
        set BLFAngle to MaxFlapAngle.
    }else if (BLFAngle<MinFlapAngle){
        set BLFAngle to MinFlapAngle.
    }
    if (BRFAngle>MaxFlapAngle){
        set BRFAngle to MaxFlapAngle.
    }else if (BRFAngle<MinFlapAngle){
        set BRFAngle to MinFlapAngle.
    }

    partlist[TRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", TRFAngle).//top right
    partlist[TLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", TLFAngle).//top left

    partlist[BRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", BRFAngle).//bootom right
    partlist[BLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", BLFAngle).//bottom left

    // //Adjust TargetForAngle to keep velocity vector close to vertical as posible.
    // if(isDryTest = false){
    //     if (ForeAngleToVel < 90){
    //         set TargetForAngle to TargetForAngle-0.5.
    //     }else{
    //         set TargetForAngle to TargetForAngle+0.5.
    //     } 
    // }

    
    
    
    if (ship:GROUNDSPEED<800 and TopFlapAngleDefoult>125){       
            set TopFlapAngleDefoult to TopFlapAngleDefoult - 0.2.
            set BottomFlapAngleDefoult to BottomFlapAngleDefoult - 0.2.
    }
    
}.




function DrawVec{

    // SET cros TO VECDRAW(
    //   V(0,0,0),
    //   VCRS(SHIP:VELOCITY:surface, SHIP:up:vector),
    //   RGB(1,0.5,0.2),
    //   "anArrow44",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).

    // SET anArrow44 TO VECDRAW(
    //   V(0,0,0),
    //   VCRS(SHIP:VELOCITY:surface, SHIP:up:vector),
    //   //SHIP:UP:vector + R(0,(VANG(SHIP:VELOCITY:orbit, SHIP:up:vector)-70) * -1,0),
    //   RGB(0,0.7,1),
    //   "anArrow44",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).
    //     SET anArrow44 TO VECDRAW(
    //   V(0,0,0),
    //   Vb,
    //   //SHIP:UP:vector + R(0,(VANG(SHIP:VELOCITY:orbit, SHIP:up:vector)-70) * -1,0),
    //   RGB(1,0.7,0),
    //   "anArrow44",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).

    // SET anArrow TO VECDRAW(
    //   V(0,0,0),
    //   SHIP:FACING:vector,
    //   RGB(1,0,0),
    //   "",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).

    SET anArrow2 TO VECDRAW(
      V(0,0,0),
      SHIP:UP:vector,
      RGB(0,1,0),
      "UP",
      20.0,
      TRUE,
      0.005,
      TRUE,
      TRUE
    ).

    SET anArrow3 TO VECDRAW(
      V(0,0,0),
      SHIP:VELOCITY:SURFACE,
      RGB(0,0,1),
      "",
      1.0,
      TRUE,
      0.5,
      TRUE,
      TRUE
    ).
    // SET anArrow6 TO VECDRAW(
    //   V(0,0,0),
    //   SHIP:VELOCITY:orbit,
    //   RGB(1,0,1),
    //   "",
    //   1.0,
    //   TRUE,
    //   0.5,
    //   TRUE,
    //   TRUE
    // ).

    // SET anArrow4 TO VECDRAW(
    //   V(0,0,0),
    //   SHIP:FACING:UPVECTOR,
    //   RGB(1,0.5,0.5),
    //   "",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).
    
    // SET anArrow5 TO VECDRAW(
    //   V(0,0,0),
    //   SHIP:FACING:STARVECTOR,
    //   RGB(0,1,1),
    //   "",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).
    // //Create a vector to center of kerbin
    // set geo to kerbin:position.
    // set geo:mag to (ship:altitude/2).
    // //Draw global axes for frame of reference
    // //                      /startPos/ /vector/  //color//        /label/  /size/
    // set xAxis to VECDRAWARGS( geo, V(200000,0,0), RGB(1.0,0.5,0.5), "X axis", 5, TRUE ).
    // set yAxis to VECDRAWARGS( geo, V(0,200000,0), RGB(0.5,1.0,0.5), "Y axis", 5, TRUE ).
    // set zAxis to VECDRAWARGS( geo, V(0,0,200000), RGB(0.5,0.5,1.0), "Z axis", 5, TRUE ).
}.
