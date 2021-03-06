// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.7
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0 // For the dropshadow
import UM 1.1 as UM
import Cura 1.0 as Cura


Button
{
    id: button
    property bool isIconOnRightSide: false

    property alias iconSource: buttonIconLeft.source
    property alias textFont: buttonText.font
    property alias cornerRadius: backgroundRect.radius
    property alias tooltip: tooltip.text
    property alias cornerSide: backgroundRect.cornerSide

    property color color: UM.Theme.getColor("primary")
    property color hoverColor: UM.Theme.getColor("primary_hover")
    property color disabledColor: color
    property color textColor: UM.Theme.getColor("button_text")
    property color textHoverColor: textColor
    property color textDisabledColor: textColor
    property color outlineColor: color
    property color outlineHoverColor: hoverColor
    property color outlineDisabledColor: outlineColor
    property alias shadowColor: shadow.color
    property alias shadowEnabled: shadow.visible

    // This property is used to indicate whether the button has a fixed width or the width would depend on the contents
    // Be careful when using fixedWidthMode, the translated texts can be too long that they won't fit. In any case,
    // we elide the text to the right so the text will be cut off with the three dots at the end.
    property var fixedWidthMode: false

    leftPadding: UM.Theme.getSize("default_margin").width
    rightPadding: UM.Theme.getSize("default_margin").width
    height: UM.Theme.getSize("action_button").height
    hoverEnabled: true

    contentItem: Row
    {
        //Left side icon. Only displayed if !isIconOnRightSide.
        UM.RecolorImage
        {
            id: buttonIconLeft
            source: ""
            height: buttonText.height
            width: visible ? height : 0
            sourceSize.width: width
            sourceSize.height: height
            color: button.hovered ? button.textHoverColor : button.textColor
            visible: source != "" && !button.isIconOnRightSide
            anchors.verticalCenter: parent.verticalCenter
        }

        Label
        {
            id: buttonText
            text: button.text
            color: button.enabled ? (button.hovered ? button.textHoverColor : button.textColor): button.textDisabledColor
            font: UM.Theme.getFont("action_button")
            visible: text != ""
            renderType: Text.NativeRendering
            anchors.verticalCenter: parent.verticalCenter
            width: fixedWidthMode ? button.width - button.leftPadding - button.rightPadding : undefined
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
        }

        //Right side icon. Only displayed if isIconOnRightSide.
        UM.RecolorImage
        {
            id: buttonIconRight
            source: buttonIconLeft.source
            height: buttonText.height
            width: visible ? height : 0
            sourceSize.width: width
            sourceSize.height: height
            color: buttonIconLeft.color
            visible: source != "" && button.isIconOnRightSide
            anchors.verticalCenter: buttonIconLeft.verticalCenter
        }
    }

    background: Cura.RoundedRectangle
    {
        id: backgroundRect
        cornerSide: Cura.RoundedRectangle.Direction.All
        color: button.enabled ? (button.hovered ? button.hoverColor : button.color) : button.disabledColor
        radius: UM.Theme.getSize("action_button_radius").width
        border.width: UM.Theme.getSize("default_lining").width
        border.color: button.enabled ? (button.hovered ? button.outlineHoverColor : button.outlineColor) : button.outlineDisabledColor
    }

    DropShadow
    {
        id: shadow
        // Don't blur the shadow
        radius: 0
        anchors.fill: backgroundRect
        source: backgroundRect
        verticalOffset: 2
        visible: false
        // Should always be drawn behind the background.
        z: backgroundRect.z - 1
    }

    ToolTip
    {
        id: tooltip
        text: ""
        delay: 500
        visible: text != "" && button.hovered
    }
}