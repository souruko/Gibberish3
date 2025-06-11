# Gibberish

## Installation

...\Documents\The Lord of the Rings Online\plugins\Gibberish3
  
## Configs

https://lotro-gibberish.com/  || by mydnic

## Changlog

### 3.1.7
- added test timer button to timer > general
- fixed permanent timer reset display
- allowed timer selection text multiline
- hovered buttons will now be highlighted
- collection is now sorted a-z
- selecting a window now automaticly selects the first timer
- permanent timers now work properly with changing stacking to single
- fixed transparent edges around icons
- fixed counter window creation


### 3.1.6
- fixed color deep copy error || contributed by ***Dromo***
- fixed folder deletion error || contributed by ***Dromo***


### 3.1.5
- added &target as placeholder for custom texts
- added excludeSelf option for group effect triggers
- fixed color4 on load error


### 3.1.4
- fixed saving group effect triggers


### 3.1.3
- fixed icon position outside of threshold
- changed how placeholders( &1 ) work by usesing captures( https://www.lua.org/pil/20.3.html ) || contributed by ***Tsu***
- added trigger options for effects (type, curable, category)


### 3.1.2
- fixed list of targets for targeteffects
- added new options: threshold (timer color, text color, opacity, font, fontSize)
- added threshold animation zoom for icons


### 3.1.1
- fixed stacking after import
- fixed a bug with enabling folders within folders per trigger
- fixed initial text for counter bars
- fixed save notification


### 3.0.11
- fixed a bug with checkboxing always sending an error message
- fixed a bug where the icon made the background transparent even if not displayed
- added &name and &class as placeholder for tokens
- added save notification


### 3.0.10
- fixed an issue with looping text timer
- fixed the german client now properly load the character savefile
- added folder ex/import
- fixed a bug that broke the plugin after saving a color as ""
- fixed a bug that caused deleting folders to lag
- added copy folder
- fixed counter resizing
- fixed direction/orientation for counters
- added sort direction for counters
- fixed counter bar progress


### 3.0.9
- fixed timerstart/end/threshold on window/folder work now
- improved tooltips
- added german options language
- fixed changing options language now gets properly passed down
- added outline and threshold color option
- fixed an issue with parsing combat chat
- added french options language
- improved folders in window selection


### 3.0.8b
- fixed importing timers with 'protect' will now properly use the value
- fixed importing timer/timerlist with create new now properly creates a window
- fixed the plugin now loads without the Turbine folder


### 3.0.8
- fixed sort direction did not copy
- fixed use custom timer works now after import
- fixed a initial position error with permanent timers
- fixed looping option
- fixed bar now nolonger is affected by opacity
- added new timer option 'protect'
- fixed permanent timer start opacity
- fixed permanent timer threshold color reset
- fixed import timer/timerlist with create new
- fixed importing timerstart/end/threshold triggers now keeps the token


### 3.0.7
- self effect remove as timer add trigger now uses the correct starting time
- export now autoselects the text
- improved export strings
- fixed a bug where timer type changes did not take effect
- fixed window orientation/direction
- changed move window ui
- added sort direction to window options
- added tracking new skills after traitline changed
- fixed timertype on import
- fixed window will now be created on import


### 3.0.6
- icon update
- fixed a bug where counter did not start with the start value
- added window type to window selection item
- more options are saved per character now
- fixed a bug where only bar timer where saved on reload
- added a scrollbar to the dropdown element
- added export / import
- fixed listOfTargets in options


### 3.0.5
- fixed a bug with targetname text option
- fixed a bug where permanent timers got removed with remove action
- added feature to save timers on reload
- fixed a bug where deleting did not deselect the trigger
- window/folder sorting now saves per character
- preselected folder/window trigger are now properly displayed
- fixed a bug in window selection where folder/window would move when clicked
- added a dropdown selection for timer_triggers(start/end/threshold)
- added icon as trigger requirement for effects
- fixed a folder id issue where id's where skiped
- added a center line(crosshair) to movewindows


### 3.0.4
- clear collection filter button works now
- collection nolonger shows gibberish as time for permanent effects
- collection now collects all activ effects after starting to collect effects
- collection checkboxes onlySay/onlyDebuffs work now
- added key event esc to close options
- added reset on target changed option
- added auto reload
- added a color control to the color row
- added a icon row options element
- fixed parse combat chat


### 3.0.3
- added collection
- fixed collection filter
- fixed opacity not working
- fixed icon size not working
- window selection > dragging onto the background should now sort the item to the bottom
- folder/window trigger are now working properly
- folder triggers iterate child folders now
- fixed an issue with stacking the same effects multiple times
- fixed a copy/loading issue with listOfTargets
- added the possiblilty to use placeholders to move values within a timer
- increased window/folder selection item height to allow 2 rows for the name


### 3.0.2
- counter_bar :save() wird jetzt an trigger weitergeben
- fixed timer direction used window direction value
- fixed a bug with reloading while move_windows is activ
- in windowselection you can now remove item from folders
- you nolonger need to reload before skilltrigger are caught
- drop_down_menu now properly hides after losing focus
- added color options
- added a frame to the tabwindows


### 3.0.1
- fixed rename folder/window