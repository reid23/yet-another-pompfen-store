# yet-another-pompfen-store

Pompfen engineered for robustness, maintainability, accessibility, and performance.

> [!IMPORTANT]
> This content is licensed under [AGPL v3](LICENSE)[^1] because I want to encourage sharing within the community.
> I hope that I'm never going to have to argue about the details with anyone about this. The main things I want are:
>  - If you use this in your own work (directly, or even just borrowing some design features), you must also release your work under AGPL v3. 
>  - If you designed your parts in a different cad software, please share the designs in the native format or STEP. I don't think mesh files count as "source".
>  - While not required by the license, attribution would be nice!  
> 
> I am uploading this work for free use (in all senses) because I want to see Jugger continue to grow and the equipment to improve. Please carry that spirit forward.

## TLDR

- See [order.md](docs/order.md) for information on ordering and poke around the configuration options & prices at [reid.xz.ax/yaps](reid.xz.ax/yaps) (looks better on a computer than on mobile).
- See [code.md](docs/code.md) for information on this codebase and how to work with it.
- See [build-your-own.md](docs/build-your-own.md) for how to build these yourself!

## Features

Really this section should be after the motivation/project goals bit, but I know everyone just wants to read the cool feature list first. So here it is:

- Modularity: the core, blade, buffer, and cover are all separate parts which can be repaired or replaced independently.
  - The buffer is a small piece of foam at the back of all blades except q-tip. It is squishy, protecting the blade-core interface from large forces when a chain wraps and tugs.
  - Removing or installing a blade takes less than a minute.
- Lightweight: these sticks are very light. It's not the bleeding edge of lightweight performance, but it's pretty damn good. As a general reference, the Q-tip is <250g.
- No more spacers! The foam has a hole inside the same size as the core.
- Nylon ripstop blade covers: instead of clear tape, we use nylon ripstop fabric. Tears propagate way less, it's lighter, it's replaceable, it (imo) looks better, it can be removed and washed, and it can be made from a variety of colors for customization.
- Long and Staff blades are interchangeable!
- Short and Qtip blades are *nearly* interchangeable. Qtip blades are just short blades without the buffer and with a smaller cover. In a pinch, qtip blades will work as short blades, though to convert a short blade to a qtip blade you'd need to get a different cover.
- Choose between a wide (3") or narrow (2.25") staff guard
- EPP reinforcement at the ends of the blades gives Qtip players more control and protects the edge of the foam on all weapons.


## OKRs

Here's what this project is trying to do.

When developing these pompfen, I was focused on the following objectives:
- be unquestionably rule compliant
- be safe in normal use and in failure
- be maintainable
- be accessible
- be lightweight
- look good

In order to accomplish this, I developed the following key results:
- The design and manufacturing process must be standardized and repeatable to ensure that my goals can be satisfied not just by one pompf, but many.
- The design must be modular so that individual components can be replaced instead of tearing down the whole pompf every time a small fix needs to be made.
- The pompf should withstand many different environments (heat, sun, rain, snow, etc).
- The pompf should last through regular usage for at least a year with less than $1 and 20 minutes of maintainence over the course of that year.
- All safety-critical failures must be visible and ideally not occur suddenly (I say 'ideally' because there's only so much you can do if the core snaps in half).
- The results of this effort should be made public and free (as in free beer *and* as in free speech) for the wider Jugger community to use and build upon.
- The pompf should be sold at or below typical US market rates.

Within the bounds of these constraints, I seek to optimize for weight[^2] and aesthetics.


[^1]: I am aware that this is not very well suited for hardware projects (I'm not sure if there even is a good license for OpenSCAD projects). But it captures the spirit of what I'm trying to do, and I hope that the details never become relevant anyway. Please be nice and share your work.

[^2]: technically by weight I mean some strange cost function of the inertia tensor that captures what makes a weapon maneuverable. I do assume that this function is positive definite though (ie, I do not consider the "I like heavy weapons because they make it easier to chainbreak/push through an opponent's parry/build momentum/etc.).