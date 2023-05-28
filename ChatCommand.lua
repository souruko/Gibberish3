
Command = Turbine.ShellCommand()

function Command:Execute( _, str )

    if str == nil or string.len( str ) == 0 then
        Turbine.Shell.WriteLine( "Missing Argument.")
        return
    end

    local list  = { }
    local index = 1

    for word in str:gmatch( "%w+" ) do
        list[ index ] = word
        index = index + 1
    end

    local cmd = string.lower( list[ 1 ] )

    if cmd == "options" then
        Options.MainWindow.OpenClose()

    elseif cmd == "reload" then
        Options.Reload()

    elseif cmd == "reset" then
        Group.Reset()

    elseif cmd == "collection" then

    elseif cmd == "move" then
        Options.Move.UpdateMode(not(Data.moveMode), true)

    end

end


Turbine.Shell.AddCommand( "gibberish", Command )
Turbine.Shell.AddCommand( "g", Command )