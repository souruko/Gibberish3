--=================================================================================================
--= Group Setup - French
--= ===============================================================================================
--= trait line detection data for the group setup export
--=================================================================================================
--=
--= Empty on purpose. Line detection reads the names the client shows, and these are the french
--= ones, which nobody has collected yet. Prime has the same gap: its own table is english only.
--=
--= What this costs on a french client: every group member's line reads "Undefined". Their name
--= and class are still right, because both are read from the game rather than from a name table.
--=
--= To fill it in, copy the two tables out of en.lua and replace every effect and skill name with
--= the french one. Do not guess them - a wrong name is worse than "Undefined", because it reports
--= a confident line that is simply the wrong one. Only add names that have been seen in a client.
--=================================================================================================



---------------------------------------------------------------------------------------------------
GroupSetup.LineEffects   = {}
GroupSetup.OwnLineSkills = {}
---------------------------------------------------------------------------------------------------
