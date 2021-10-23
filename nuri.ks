clearscreen.
wait 4.
stage.
lock throttle to 1.
wait 2.5.
stage.
lock inclination to 195.
set runmode to "Liftoff".
set stage2 to "n".
set tes1 to "n".

until runmode = "Done" {
	if runmode = "Liftoff" {
		if ship:apoapsis > 250000 {
			lock throttle to 0.
			set runmode to "Coastphase".
		}
		turn(inclination).
	}
	if ship:stagedeltav(ship:stagenum):current < 20 and stage2 = "n" and alt:radar > 10000 {
		wait 1.
		stage.
		wait 1.
		stage.
		set stage2 to "y".
	}
	if ship:stagedeltav(ship:stagenum):current < 20 and stage2 = "y" and tes1 = "n"{
		wait 2.
		stage.
		wait 2.
		stage.
		wait 8.
		stage.
		set tes1 to "y".
	}
	
	if runmode = "Coastphase" {
		if eta:apoapsis < 21 {
			lock throttle to 1.
		}
		if ship:periapsis > 240000 {
				lock throttle to 0.
				wait 5.
				stage.
				wait 3.
				toggle ag1.
				set runmode to "Done".
		}
	}
	
	printVesselStats().
}

function printVesselStats {
	clearscreen.
	print "Telemetry:" at(1, 4).
	print "Altitude above sea level: " + round(ship:altitude) + "m" at(10, 5).
	print "Current apoapsis: " + round(ship:apoapsis) + "m" at (10, 6).
	print "Current periapsis: " + round(ship:periapsis) + "m" at (10, 7).
	print "Orbital velocity: " + round(ship:velocity:orbit:mag * 3.6) + "km/h" at(10, 9).
}

function turn {
	parameter heading.
	if alt:radar < 100 {
		lock angle to 90.
		lock steering to heading(heading, angle).
	}
	else if alt:radar < 1000 {
		lock angle to  (-1 * alt:radar) / 90 + 90.
		lock steering to heading(heading, angle).
	}
	else if alt:radar > 60000 {
		lock steering to prograde.
	}
	else{
		lock angle to 98 - 1.03287 * alt:radar^.4.
		lock steering to heading(heading, angle).
	}
}

