# yet-another-pompfen-store

> [!IMPORTANT]
> This content is licensed with GPL v2[^1] because I want to encourage sharing within the community.
> I hope that I'm never going to have to argue about the details with anyone about this. The main things I want are:
>  - If you use this in your own work (directly, or even borrowing some design features), please also release your content under GPL v2. 
>  - If you designed your parts in a different cad software, please share the designs in the native format or STEP.
>  - While not required by the license, attribution would be nice!
> I am uploading this work for free use (in all senses) because I want to see Jugger continue to grow and the equipment to improve. Please carry that spirit forward.


## Documentation

Eventually I'll move this to a more appropriate place, but for now this is fine.
More complete statuses and specific manufacturing documentation on each part is in the New Sticks epic in the Ursae Notion.

### Setup

There shouldn't be much setup. Just clone the repo. If you don't have [BOSL2](https://github.com/BelfrySCAD/BOSL2) installed, you can just `git submodule init` and `git submodule update` to get it in the repo directory.

You may also need to `chmod +x buildall` before you can run the build script. It references `/usr/bin/python`, so if that doesn't exist, make a symlink (or change the interpreter in `buildall` or run it with python or whatever you'd like)

### Build System

I made a silly little custom build system, since openscad is funny and I couldn't find something that fits my needs.
You'll see comments above modules like this:
```openscad
// @build tip_thread_m_nodfm.stl include_dfm=false
// @build tip_thread_m.stl include_dfm=true
module tip_thread_m(
   // ...,
   include_dfm=true
){
    // ...
}
```

This tells the build system to build two stls from this module: one with the parameter `include_dfm` set to `true`, and the other `false`.

To build the .stl files, run the build script:

```bash
./buildall
```

This exports all files to the build folder. It also runs the CAM script, which generates some gcode for cutting the EPP. This is not well documented since it was just a one-off I made for myself and my specific setup. If you want to do a similar thing, you should write your own gcode. It's not hard, and you'll be able to debug it much easier.

### Assemblies

`assemblies.scad` contains all TLAs. Currently, the only complete one is the `long` module. The parts exist for short and Q, but I have not made the assemblies yet.
Staff is still under construction - I designed v1 in Fusion and haven't changed it since. I'll port it over here before the `v0.2.1` release.


## Building Your Own

The intent is to sell these, but that doesn't mean you can't make your own!
I caution that these were designed to be easy to make at a larger scale, so the time and material cost may be much higher for you.

### Overall
- recommend 0.15mm layer height max; there are small details that need to be resolved well
- try to print on the hotter side with less cooling to help layer adhesion (if you can do that without sacrificing part quality)
- when printing on top of EPP, use significant z-hop to ensure you always clear it and don't melt away little lines of EPP during travel moves
- random seam positions can be helpful if your seam is very noticeable and causing interface issues
- unless otherwise specified below, nothing should require supports. Orient the parts so that this is the case. They may be flipped in the stls.
- assumes ½" EPP.

### Assembly
 - tape over all 3dp/EPP interfaces with athletic tape. Cut holes beforehand.
  - - adding a layer of tape to the surface of the EPP increases the strength by acting as a tensile member (EPP is much stronger in compression than tension)
 - Use athletic tape on the non-splined section of blade_m to tape it to the core.
 - Tape over the edge of the pommel so it stays on the core.

### Foam
 - use ½" thick EPP sheets cut into circles with the same OD as your noodle and same ID as the 3dp part they go on
     - I clamped a hot knife foam cutter to my printer and wrote some gcode. Do a couple test cuts to see your max feedrate (don't push it too hard, any deflection will hurt your accuracy and it's faster to just do one good cut than a fast cut and a spring pass) and tune your kerf. It's like <10 lines and a good excuse to actually understand G2/3.
 - For the blade, you need to use a single piece of foam, which you can get from either pipe insulation which you take a slice out of to make the ID match the core, or from a solid noodle with a hole cut through the center (this is preferred because the seam is not a weak point)
     - see my coring jig: https://www.printables.com/model/1233976-pompf-coring-jig
 - For a staff guard, you need the ID to be large enough to fit around all the other hardware. I have used pipe insulation for this.
 - The tip should be 33mm thick on top of the EPP.
 - An additional buffer of 50mm of foam behind the EPP can help it degrade less when chainbreaking. The 50mm buffer can then be replaced easily.
     - you don't need to tape this in place if you have a tight cover

### `blade_f`
 - print with the wider flange on TOP. spline components need a tiny amount of support (helps tie everything together on the base too so they don't break apart as easily during printing and removal)
 - insert a pause right before the top flange is printed so you can insert the EPP. If it's not a secure enough press fit, tape it down.

### `blade_m`
 - print with the splines at the top to prevent elephant foot from making it not fit into blade_f nicely
 - brim recommended; there's not much contact area

### `tip_thread_m`
 - print with the threaded part on top. insert a pause before the top flange so you can insert the EPP.
 - the super skinny vertical bit between the main part and the big extra flange is sacrificial (as well as that big flange). It's so that you can print this at the same time as blade_f and put the pause to insert the EPP at the same height.
     - you need support for the small face that is connected to the skinny cylinder. Be sure to set the “snug” support style so that the EPP still fits around it.
 - use at least 5 perimeters; this part takes a lot of load.

### `pommel`
 - add a cylinder modifier centered at z=10 with h=10mm, d=25mm and set its infill percentage to like 70 or 80%. This helps prevent anyone from feeling the core, and reinforces the place that takes a lot of load
     - aside: usually it's better to add more perimeters rather than increase infill if you want more strength, but because this is a flexible part, the load gets distributed into the infill much more.
 - use 2 walls on the side AND BOTTOM.
 - 50% infill gave me a hardness I was happy with
 - I liked gyroid infill because it didn't have specific directions in which the stiffness is greatly increased (ie, because of straight lines causing buckling load cases inside - it's already pre-buckled)

### `staff_grip`
 - tune the infill percentage to your desired firmness.
 - “solid infill every N layers” can increase stiffness a lot without adding much weight


[^1]: I am aware that this is not very up to date, internationalized, or even really well suited for hardware projects (I'm not sure if there is a good license for openscad projects). But it captures the spirit of what I'm trying to do, and I hope that the details never become relevant anyway. Please be nice.
