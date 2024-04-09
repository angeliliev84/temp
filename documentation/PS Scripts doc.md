 Overview

All the scripts were created in that way to respect the single responsibililty principle and follow good design.
Each script takes care of particular task like for example Creating a RG , creating Storage Acc, setting up permissions, budgets etc.

And then all the scripts are called in the Main Powershell script (which serves as the entry, the Main orchestrator).
There's a logger implemented and exception handling.

Also there are unit tests for the scripts.

There were channelges, things mostly worked, resources were creatd.
Unit tests were failing due to wrong path( which was super strange as the psscriptroot was referrenced properly)

This whole exercise was a good one, I've enjoyed it! :)
Issue happen always in real life, but my goal here( personal choice which I stand by) was to demonstrate a way of thinking.
How I'd approach a task and how I'd jump on designing a potential solution.

I did not focus that much on technical actions, those can be done easily especially if part of the team where one can discuss or have a bit more time. Rather, again, I focused on demonstrating an approach, methodoligy and way of designing stuff.

