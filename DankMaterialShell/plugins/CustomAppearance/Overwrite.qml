import QtQuick
import Qt5Compat.GraphicalEffects // Fallback fallback if your version of Quickshell targets older Qt modules, or use QtQuick.Effects
import quickshell
import DMS.Core // Import original DMS core namespace to fetch the underlying properties

Item {
    id: shadowedPillRoot
    
    // Pass through implicit sizes so the bar layout engines don't break
    implicitWidth: corePillInstance.implicitWidth
    implicitHeight: corePillInstance.implicitHeight
    
    // Explicit sizing propagation
    width: corePillInstance.width
    height: corePillInstance.height

    /*
     * 1. THE DROP SHADOW LAYER
     * Placed first in the QML tree so it renders structurally BEHIND the pill.
     * We use RectangularShadow because pills are uniform rounded rectangles—this
     * is vastly more performant than an Alpha-channel MultiEffect shadow.
     */
    RectangularShadow {
        id: pillShadow
        anchors.fill: corePillInstance
        
        // Match the border radius of the Material 3 BasePill
        // If your layout updates radius dynamically, bind directly to the background
        radius: corePillInstance.radius || 16 
        
        // Shadow configuration (Soft Material Design Ambient elevation)
        blurRadius: 12
        spread: 0.05
        color: "#45000000" // ~27% Opacity Black
        
        // Push the shadow slightly down to simulate a top-down light source
        offsetX: 0
        offsetY: 3
        
        // Optimization: Disable tracking if the item isn't visible
        visible: corePillInstance.visible && corePillInstance.opacity > 0
    }

    /*
     * 2. THE ORIGINAL BASE PILL
     * We dynamically look up or instantiate the default layout properties.
     */
    DefaultBasePill {
        id: corePillInstance
        anchors.centerIn: parent
        
        // Re-expose standard properties so child modules (clock, battery, workspace) can bind
        property alias shadowReference: pillShadow
    }
}
