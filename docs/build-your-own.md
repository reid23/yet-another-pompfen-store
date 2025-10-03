# Building Your Own

The intent is to sell these, but that doesn't mean you can't make your own!
I caution that these were designed to be easy to make at a larger scale, so the time and material cost may be much higher for you.

> [!IMPORTANT]
> Please read this entire document before deciding to build your own. If you get halfway through and realize that this is too complicated or requires tools you don't have, it will not be very fun.

## 3D printed parts
There are rigid and flexible parts. I recommend printing the rigid parts in polypropylene, because it is very lightweight, very isotropic, quite soft, and yields and necks before breaking (instead of just shattering like PLA). I'd highly recommend getting some Magigoo PP to help with bed adhesion; PP is very hard to stick to anything.
The flexible parts are less material dependent. The provided slicing settings assume a shore hardness of ~83A, though 85A probably will work too.

Use the `flexibles.3mf` and `pp_all.3mf` files from the `slice` folder. They were exported with PrusaSlicer; I'm not sure how well that plays with other slicers. Hide/show and duplicate components based on what you need.


## Foam

There are three types of foam:
- solid core noodle, for the blade
- 1/2", 1.3lb/cubic foot EPP sheet
- 3"x1" pipe insulation or 2.25" hollow noodle for the guard (depending on how big you want your guard)

### Solid Core Noodle

For the solid core noodle, for each blade, you'll need:
- one tip, which is just a 37.3mm thick piece of solid noodle
- one buffer, a 50mm thick piece of cored solid noodle
- one blade, a 787.3mm thick piece of cored solid noodle

To create the cored noodle, you need to cut a hole of the appropriate size down the center of the solid core noodle. I have a jig to help you do that [here](https://www.printables.com/model/1233976-pompf-coring-jig/files). You heat up the brass tube with a heat gun (don't use a flame; it makes the foam stick to the tube) and push it through the noodle.

### EPP

For the EPP sheet, you'll need to cut circles. I do this by strapping a hot knife foam cutter to my 3D printer and running the gcodes in the `build` folder. Workholding is done by double-sided taping EPP rectangles to the `epp_support_[type]` part. If those parts are too big for your printer, you can set the `nrows` and `ncols` parameters by editing the `// @build` comments (see [the build system docs](code.md#build-system) for more info on how this works) above the `epp_support` module and then rebuilding.

The `three_blade_pairs.gcode` will cut three parts for the tip side of the blade and three for the hand side of the blade, but you can just stop it after the first two if you don't want that many. The same goes for the `six_[wide/narrow]_guards.gcode` files.


Before you run those, though, you may need to tune the kerf of your hot knife. Cut through the foam at 100mm/min and measure the kerf in millimeters. Divide that by two to get the radius of the cut.

First, update the `epp_support`. Pass `$kerf=<your_kerf_radius>` in the `// @build` comments above the `epp_support` module and then rebuild.
Then, from the root directory of this repo, run:

```bash
python epp_cam.py --kerf your_kerf_radius_here
```
This will generate new gcode files that will cut the shapes accurately for you.

Be sure to do these in this order, since rebuilding with `./buildall` overwrites the results of running `epp_cam.py`.


If you want to cut many pieces of EPP at once, you can use the `-z`/`--zclear` parameters to set the travel height. For more information on the arguments to `epp_cam.py`, use the standard help flag:

```bash
python epp_cam.py --help
```

### Staff Guard

There isn't much to this one. Just take your selected material and cut it to length. For a full length staff, that's 412.6mm, and 100mm less for a shortstaff.

## Covers

I'd save the covers for last, after you've assembled everything. That way it's easier to test the fit. The dimensions of the cover change based on the precise diameter of your noodle, so you'll have to tune it at least once for each cover type you make.

For blade covers, the procedure is:
1. cut a rectangle big enough for the cover
2. hem one short side to create a loop for the wire to go through
3. fold it in half the long way and pin/tape it somehow, making sure the hem on the side is on the outside
4. mark the distance from the folded edge that you plan to sew. 
5. sew it! I use a Serger style machine for this part because it's fast and I have access to one, but if you don't, a normal machine works fine. Just be sure to add multiple stitches so it doesn't fray and fall apart super fast.
6. test fit on your stick and measure & mark where you want to sew across the top
7. turn it back inside out and sew a straight line across the top
8. sew the two corners together and trim any excess fabric
9. use a lighter to clean up any wispies and seal in the edges of the ripstop, especially around the hem you made in step 2.
10. Cut a small hole in the loop of the hem where you can insert the wire.

For guard covers, the procedure is the exact same, except that you should hem both short sides and you don't need to close off the tip.


## Assembly

### Cores

Cut the cores to the appropriate length. The nominal core lengths are:
- short: 838mm
- long: 1388mm
- Staff: 1788mm (100mm shorter for shortstaff)
- Qtip: 1896mm

In reality you often want to cut them a little shorter to make sure you're safely within the legal length. How much you take off is up to you.

Then, measure out where the hardware is supposed to go on the core, ensuring you have the clearances in the right direction to be legal. (I'll write up measurements with clearance directions specified here eventually but I believe in you to figure it out).
Then, everywhere you have to attach a (non-removable) printed part, sand the core a little bit to scratch the surface, clean it, and then superglue the part on. Try to put a little glue on the edges of the part as well to provide a more mechanical means of locking the part in place.
Depending on your core's tolerances, you may need to wrap the printed part in a few layers of tape or sand it down before it fits snugly. Make sure it's a snug fit before applying glue.

For `blade_m`, make sure the blank part is on the hand side of the blade. Wrap it in some athletic tape and put heat shrink over that to prevent peeling.

For staffs, use small bits of heat shrink to create stops on the core to hold the four `staff_guard_spacer`s in place.

### Blades

> [!IMPORTANT]
> **On the Use of Tape**  
> To ensure the strength and longevity of taped joints, make sure that you:
> - minimize touching the adhesive with anything
> - minimize the amount of dust in the air (ie, don't do this in a woodshop)
> - apply firm pressure on every piece of tape to ensure the adhesive activates and forms a good bond
> - ensure target surfaces are clean, especially from any sorts of oils.
> - ensure that tape is loaded fairly evenly across its width, especially since both athletic and spinnaker tape do not provide much shear strength.
> - minimize any wrinkles and sharp exposed tape corners; these are things that can catch on things and reduce effective adhesive area.

First, tape the EPP assemblies. These should be done with athletic tape that is at least 2" wide.

For `tip_epp` and `tip_thread_m`:
1. Tape across the center of one side with athletic tape. 
2. get enough tape to wrap around the whole piece of EPP once. Fold it over the edge of a piece of parchment paper, with the edge in the center of the tape. Cut a circular hole in the middle about 5/8" in diameter (or use a hole punch of that size).
3. Peel the tape off and use it to tape `tip_thread_m` onto the center of the EPP on the side with the tape (on top of the tape). Be sure that the force distribution across the width of the tape is fairly even.
4. Repeat steps 2 and 3 again, placing the second piece of tape perpendicular to the first.

For `blade_epp` and `blade_f`:
1. insert `blade_f` into `blade_epp`
2. Tape a full loop around the assembly, making sure that the tape connects back to itself.
3. Add another piece of tape the same way, perpendicular to the first.
4. Using flush cutters, cut out holes in the center of both sides of the tape. On the outside (where you put in the collet), ensure that the hole in the tape is at least as large as the hole in the EPP. On the other side, just make it as small as possible while still clearing the hole in the printed part. **Important**: make sure you don't cut all the way to the edge of any piece of tape. Make sure there's enough tape left around the edges to carry the tension around the hole.

Now, attach the EPP assemblies to the main blade foam. From here on out, use spinnaker tape for everything.

For the tip side assembly:

1. cut a 24cm length of tape, and round one corner (like a 5-10mm radius)
2. on the long side without the rounded corner, cut evenly spaced slits about 1cm down from the edge, spaced 10-15mm apart. The actual length of the slits isn't super important, but try to make them all about the same length, and ensure there's at least an inch of tape remaining unslitted.
3. put the `tip_epp` and `tip_thread_m` assembly onto the end of the blade foam. The `tip_thread_m` will make this a little hard because it has to squish the blade foam out of the way. This is okay.
4. Starting with the end of the tape without the rounded corner, apply the tape in a loop around the blade, connecting the EPP and blade. The slitted part should be above the EPP, with the ends of the slits aligning with the top edge of the EPP. When doing this, push the EPP into the blade so that there's no gap between the two when they're taped together.
5. Starting with the same side you started taping on, fold each tab of the tape down onto the EPP, pushing the EPP down as you do to apply axial preload (ie, along the axis of the weapon).

For the blade side assembly, do the exact same, just on the other end of the blade.

Now, we need to add the tip:
1. Take the solid tip foam and put it on top of the tip EPP. 
2. Cut two 26cm pieces of tape and round all of their corners.
3. Tape the tip down by placing the tape up and over the center of the tip foam.

When taping, be sure that there is some preload and that the tensile stress profile across the width of each piece of tape is somewhat even (to help spread the load into the foam more evenly and thus reduce shear stresses within the foam).

> [!NOTE]
> It may be better to just put the up and over tape pieces on the EPP (under the tip foam) instead of the hoop with slits, then just use a simple hoop without slits+tabs to hold the tip foam on. This leaves the top of the tip foam relatively unprotected, but it should be fine with the ripstop. This has not been sufficiently tested, but it seems to have promise:
> - it's much faster to assemble
> - tape will reach further down the blade foam, distributing the load from tip moments better
> - it provides more tension members across the top of the tip EPP, which could reduce the amount of athletic tape needed and definitely increases the strength of the EPP
> 
> In a few weeks I'll have much better data on whether this is actually better and will update this document with the results.

### Staff Guards

First, assemble one `guard_epp` and the `guard_thread_f`:
1. put them together
2. wrap them in two loops of athletic tape, the second loop perpendicular to the first.
3. use flush cutters to cut holes in the tape, with the same caution as for `blade_epp` and `blade_f`. Particularly ensure that on the flange side, the tape does not hang over the hole at all.

Now, put the `guard_epp` and `guard_thread_f` assembly on the guard foam (the insulation or hollow noodle). Make sure the flange of `guard_thread_f` is sandwiched between the EPP and guard foam. Use a hoop of athletic tape to attach the two.

Then, use another loop of athletic tape to attach the second `guard_epp` to the other end of the guard foam.

Finally, put the guard cover over the guard and use one piece of wire on each side to affix it.

### Final Assembly

First, put the pommel on, if the stick you're building has one.

Then, if you're building a staff:

1. put the four `staff_guard_spacer`s on between the heat shrink collars. 
2. put the guard foam on and thread it down until it is tightened. Don't put more than like 0.5 Nm into tightening it.
3. put the `staff_spacer` over the core in front of the guard foam.
4. put the `staff_grip` over the spacer.

Then, install the blade. If you aren't making a Qtip, put the buffer foam on the core and slide it past `blade_m`. After that, put the `collet` on the core. Finally, put the blade on! Slide it all the way down the core until the tip of the core goes into `tip_thread_m`. From there, hold the blade side EPP (and `blade_f`) away from `blade_m` (so they don't interact while you do this) and screw the core into the blade. Rotate the core at least 4 times; it will never tighten and that is okay. You can check that it's screwed in properly by pulling the blade gently off and seeing if it can be removed without screwing.

Once the tip is screwed in, pull the blade side EPP over the spline (`blade_m`) and push the `collet` in to lock it. Then you can push the buffer foam, if present, up against the EPP, pull the cover over it, and secure it by cinching it with the wire.
