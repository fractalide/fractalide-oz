functor
import
    OS
    Browser
define A
    {Browser.browse {OS.getPID}}
    {OS.kill {OS.getPID} 'SIGTERM' A}
    {Browser.browse A}
    {Browser.browse {OS.getPID}}
end