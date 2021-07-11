///@function imguigml_defines()
///@desc enums / definitions for imguigml
function imguigml_defines() {

	// easy access to ImGui
#macro ImGuiGML (global.__imguigml)

	// ImGui Enums
#region EImGui_WindowFlags
	enum EImGui_WindowFlags {
	    NoTitleBar                = 1 << 0,   // Disable title-bar
	    NoResize                  = 1 << 1,   // Disable user resizing with the lower-right grip
	    NoMove                    = 1 << 2,   // Disable user moving the window
	    NoScrollbar               = 1 << 3,   // Disable scrollbars (window can still scroll with mouse or programatically)
	    NoScrollWithMouse         = 1 << 4,   // Disable user vertically scrolling with mouse wheel. On child window, mouse wheel will be forwarded to the parent unless NoScrollbar is also set.
	    NoCollapse                = 1 << 5,   // Disable user collapsing window by double-clicking on it
	    AlwaysAutoResize          = 1 << 6,   // Resize every window to its content every frame
	    NoBackground              = 1 << 7,   // Disable drawing background color (WindowBg, etc.) and outside border. Similar as using SetNextWindowBgAlpha(0.0f).
	    NoSavedSettings           = 1 << 8,   // Never load/save settings in .ini file
	    NoMouseInputs             = 1 << 9,   // Disable catching mouse or keyboard inputs, hovering test with pass through.
	    MenuBar                   = 1 << 10,  // Has a menu-bar
	    HorizontalScrollbar       = 1 << 11,  // Allow horizontal scrollbar to appear (off by default). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
	    NoFocusOnAppearing        = 1 << 12,  // Disable taking focus when transitioning from hidden to visible state
	    NoBringToFrontOnFocus     = 1 << 13,  // Disable bringing window to front when taking focus (e.g. clicking on it or programatically giving it focus)
	    AlwaysVerticalScrollbar   = 1 << 14,  // Always show vertical scrollbar (even if ContentSize.y < Size.y)
	    AlwaysHorizontalScrollbar = 1<< 15,  // Always show horizontal scrollbar (even if ContentSize.x < Size.x)
	    AlwaysUseWindowPadding    = 1 << 16,  // Ensure child windows without border uses style.WindowPadding (ignored by default for non-bordered child windows, because more convenient)
	    ResizeFromAnySide         = 1 << 17,  // (WIP) Enable resize from any corners and borders. Your back-end needs to honor the different values of io.MouseCursor set by imgui.
			NoNavInputs               = 1 << 18,  // No gamepad/keyboard navigation within the window
			NoNavFocus                = 1 << 19,  // No focusing toward this window with gamepad/keyboard navigation (e.g. skipped by CTRL+TAB)
			UnsavedDocument           = 1 << 20,  // Append '*' to title without affecting the ID, as a convenience to avoid using the ### operator. When used in a tab/docking context, tab is selected on closure and closure is deferred by one frame to allow code to cancel the closure (with a confirmation popup, etc.) without flicker.

	    NoNav                     = EImGui_WindowFlags.NoNavInputs   | EImGui_WindowFlags.NoNavFocus,
	    NoDecoration              = EImGui_WindowFlags.NoTitleBar    | EImGui_WindowFlags.NoResize    | EImGui_WindowFlags.NoScrollbar | EImGui_WindowFlags.NoCollapse,
	    NoInputs                  = EImGui_WindowFlags.NoMouseInputs | EImGui_WindowFlags.NoNavInputs | EImGui_WindowFlags.NoNavFocus,
	};

#endregion
#region EImGui_InputTextFlags
	// Flags for ImGui::InputText()
	enum EImGui_InputTextFlags {
	    // Default: 0
	    CharsDecimal        = 1 << 0,   // Allow 0123456789.+-*/
	    CharsHexadecimal    = 1 << 1,   // Allow 0123456789ABCDEFabcdef
	    CharsUppercase      = 1 << 2,   // Turn a..z into A..Z
	    CharsNoBlank        = 1 << 3,   // Filter out spaces, tabs
	    AutoSelectAll       = 1 << 4,   // Select entire text when first taking mouse focus
	    EnterReturnsTrue    = 1 << 5,   // Return 'true' when Enter is pressed (as opposed to when the value was modified)
	    CallbackCompletion  = 1 << 6,   // Call user function on pressing TAB (for completion handling)
	    CallbackHistory     = 1 << 7,   // Call user function on pressing Up/Down arrows (for history handling)
	    CallbackAlways      = 1 << 8,   // Call user function every time. User code may query cursor position, modify text buffer.
	    CallbackCharFilter  = 1 << 9,   // Call user function to filter character. Modify data->EventChar to replace/filter input, or return 1 to discard character.
	    AllowTabInput       = 1 << 10,  // Pressing TAB input a '\t' character into the text field
	    CtrlEnterForNewLine = 1 << 11,  // In multi-line mode, unfocus with Enter, add new line with Ctrl+Enter (default is opposite: unfocus with Ctrl+Enter, add line with Enter).
	    NoHorizontalScroll  = 1 << 12,  // Disable following the cursor horizontally
	    AlwaysInsertMode    = 1 << 13,  // Insert mode
	    ReadOnly            = 1 << 14,  // Read-only mode
	    Password            = 1 << 15,  // Password mode, display all characters as '*'
	    NoUndoRedo          = 1 << 16,  // Disable undo/redo. Note that input text owns the text data while active, if you want to provide your own undo/redo stack you need e.g. to call ClearActiveID().
	    CharsScientific     = 1 << 17,  // Allow 0123456789.+-*/eE (Scientific notation input)
	    // CallbackResize   = 1 << 18,  // [UNSUPPORTED IN IMGUIGML] Callback on buffer capacity changes request (beyond 'buf_size' parameter value), allowing the string to grow. Notify when the string wants to be resized (for string types which hold a cache of their Size). You will be provided a new BufSize in the callback and NEED to honor it. (see misc/cpp/imgui_stdlib.h for an example of using this)
	};
                                                       
#endregion
#region EImGui_TreeNodeFlags
	// Flags for ImGui::TreeNodeEx(), ImGui::CollapsingHeader*()
	enum EImGui_TreeNodeFlags {
	    Selected             = 1 << 0,   // Draw as selected
	    Framed               = 1 << 1,   // Full colored frame (e.g. for CollapsingHeader)
	    AllowItemOverlap     = 1 << 2,   // Hit testing to allow subsequent widgets to overlap this one
	    NoTreePushOnOpen     = 1 << 3,   // Don't do a TreePush() when open (e.g. for CollapsingHeader) = no extra indent nor pushing on ID stack
	    NoAutoOpenOnLog      = 1 << 4,   // Don't automatically and temporarily open node when Logging is active (by default logging will automatically open tree nodes)
	    DefaultOpen          = 1 << 5,   // Default node to be open
	    OpenOnDoubleClick    = 1 << 6,   // Need double-click to open node
	    OpenOnArrow          = 1 << 7,   // Only open when clicking on the arrow part. If ImGuiTreeNodeFlags_OpenOnDoubleClick is also set, single-click arrow or double-click all box to open.
	    Leaf                 = 1 << 8,   // No collapsing, no arrow (use as a convenience for leaf nodes). 
	    Bullet               = 1 << 9,   // Display a bullet instead of arrow
	    FramePadding         = 1 << 10,  // Use FramePadding (even for an unframed text node) to vertically align text baseline to regular widget height. Equivalent to calling AlignTextToFramePadding().
	    //SpanAllAvailWidth  = 1 << 11,  // FIXME: TODO: Extend hit box horizontally even if not framed
	    //NoScrollOnOpen     = 1 << 12,  // FIXME: TODO: Disable automatic scroll on TreePop() if node got just open and contents is not visible
	    NavLeftJumpsBackHere = 1 << 13,  // (WIP) Nav: left direction may move to this TreeNode() from any of its child (items submitted between TreeNode and TreePop)
    
	    CollapsingHeader     = EImGui_TreeNodeFlags.Framed | EImGui_TreeNodeFlags.NoAutoOpenOnLog
	};
#endregion
#region EImGui_SelectableFlags
	// Flags for ImGui::Selectable()
	// ImGuiSelectableFlags
	enum EImGui_SelectableFlags {
	    // Default: 0
	    DontClosePopups    = 1 << 0,   // Clicking this don't close parent popup window
	    SpanAllColumns     = 1 << 1,   // Selectable frame can span all columns (text will still fit in current column)
	    AllowDoubleClick   = 1 << 2,   // Generate press events on double clicks too
			Disabled           = 1 << 3    // Cannot be selected, display grayed out text
	};

#endregion 
#region EImGui_ComboFlags
	// Flags for ImGui::BeginCombo()
	enum EImGui_ComboFlags
	{
	    PopupAlignLeft          = 1 << 0,   // Align the popup toward the left by default
	    HeightSmall             = 1 << 1,   // Max ~4 items visible. Tip: If you want your combo popup to be a specific size you can use SetNextWindowSizeConstraints() prior to calling BeginCombo()
	    HeightRegular           = 1 << 2,   // Max ~8 items visible (default)
	    HeightLarge             = 1 << 3,   // Max ~20 items visible
	    HeightLargest           = 1 << 4,   // As many fitting items as possible
			NoArrowButton           = 1 << 5,   // Display on the preview box without the square arrow button
	    NoPreview               = 1 << 6,   // Display only a square arrow button
		
	    HeightMask_             = EImGui_ComboFlags.HeightSmall | EImGui_ComboFlags.HeightRegular | EImGui_ComboFlags.HeightLarge | EImGui_ComboFlags.HeightLargest
	};
#endregion
#region EImGui_TabBarFlags
	enum EImGui_TabBarFlags {
    
	    Reorderable                    = 1 << 0,   // Allow manually dragging tabs to re-order them + New tabs are appended at the end of list
	    AutoSelectNewTabs              = 1 << 1,   // Automatically select new tabs when they appear
	    TabListPopupButton             = 1 << 2,   // Disable buttons to open the tab list popup
	    NoCloseWithMiddleMouseButton   = 1 << 3,   // Disable behavior of closing tabs (that are submitted with p_open != NULL) with middle mouse button. You can still repro this behavior on user's side with if (IsItemHovered() && IsMouseClicked(2)) *p_open = false.
	    NoTabListScrollingButtons      = 1 << 4,   // Disable scrolling buttons (apply when fitting policy is ImGuiTabBarFlags_FittingPolicyScroll)
	    NoTooltip                      = 1 << 5,   // Disable tooltips when hovering a tab
	    FittingPolicyResizeDown        = 1 << 6,   // Resize tabs when they don't fit
	    FittingPolicyScroll            = 1 << 7,   // Add scroll buttons when tabs don't fit
    
	    FittingPolicyMask_             = EImGui_TabBarFlags.FittingPolicyResizeDown | EImGui_TabBarFlags.FittingPolicyScroll,
	    FittingPolicyDefault_          = EImGui_TabBarFlags.FittingPolicyResizeDown
	}

#endregion
#region EImGui_TabItemFlags
	enum EImGui_TabItemFlags {
	    UnsavedDocument               = 1 << 0,   // Append '*' to title without affecting the ID, as a convenience to avoid using the ### operator. Also: tab is selected on closure and closure is deferred by one frame to allow code to undo it without flicker.
	    SetSelected                   = 1 << 1,   // Trigger flag to programmatically make the tab selected when calling BeginTabItem()
	    NoCloseWithMiddleMouseButton  = 1 << 2,   // Disable behavior of closing tabs (that are submitted with p_open != NULL) with middle mouse button. You can still repro this behavior on user's side with if (IsItemHovered() && IsMouseClicked(2)) *p_open = false.
	    NoPushId                      = 1 << 3    // Don't call PushID(tab->ID)/PopID() on BeginTabItem()/EndTabItem()
	}
#endregion
#region EImGui_FocusedFlags
	enum EImGui_FocusedFlags
	{
	    ChildWindows                  = 1 << 0,   // IsWindowFocused(): Return true if any children of the window is focused
	    RootWindow                    = 1 << 1,   // IsWindowFocused(): Test from root window (top most parent of the current hierarchy)
	    AnyWindow                     = 1 << 2,   // IsWindowFocused(): Return true if any window is focused. Important: If you are trying to tell how to dispatch your low-level inputs, do NOT use this. Use ImGui::GetIO().WantCaptureMouse instead.
			RootAndChildWindows           = EImGui_FocusedFlags.RootWindow | EImGui_FocusedFlags.ChildWindows
	};

#endregion
#region EImGui_HoveredFlags
	// Flags for ImGui::IsItemHovered(), ImGui::IsWindowHovered()
	// Note: if you are trying to check whether your mouse should be dispatched to imgui or to your app, you should use the 'io.WantCaptureMouse' boolean for that. Please read the FAQ!
	// Note: windows with the ImGuiWindowFlags_NoInputs flag are ignored by IsWindowHovered() calls.
	// ImGuiHoveredFlags
	enum EImGui_HoveredFlags
	{
	    None                          = 0,        // Return true if directly over the item/window, not obstructed by another window, not obstructed by an active popup or modal blocking inputs under them.
	    ChildWindows                  = 1 << 0,   // IsWindowHovered() only: Return true if any children of the window is hovered
	    RootWindow                    = 1 << 1,   // IsWindowHovered() only: Test from root window (top most parent of the current hierarchy)
	    AnyWindow                     = 1 << 2,   // IsWindowHovered() only: Return true if any window is hovered
	    AllowWhenBlockedByPopup       = 1 << 3,   // Return true even if a popup window is normally blocking access to this item/window
	  //AllowWhenBlockedByModal       = 1 << 4,   // Return true even if a modal popup window is normally blocking access to this item/window. FIXME-TODO: Unavailable yet.
	    AllowWhenBlockedByActiveItem  = 1 << 5,   // Return true even if an active item is blocking access to this item/window. Useful for Drag and Drop patterns.
	    AllowWhenOverlapped           = 1 << 6,   // Return true even if the position is overlapped by another window
	    AllowWhenDisabled             = 1 << 7,   // Return true even if the item is disabled
	    RectOnly                      = EImGui_HoveredFlags.AllowWhenBlockedByPopup | EImGui_HoveredFlags.AllowWhenBlockedByActiveItem | EImGui_HoveredFlags.AllowWhenOverlapped,
	    RootAndChildWindows           = EImGui_HoveredFlags.RootWindow | EImGui_HoveredFlags.ChildWindows
	};
#endregion
#region EImGui_DragDropFlags
	enum EImGui_DragDropFlags {
	    // BeginDragDropSource() flags
	    SourceNoPreviewTooltip       = 1 << 0,       // By default, a successful call to BeginDragDropSource opens a tooltip so you can display a preview or description of the source contents. This flag disable this behavior.
	    SourceNoDisableHover         = 1 << 1,       // By default, when dragging we clear data so that IsItemHovered() will return true, to avoid subsequent user code submitting tooltips. This flag disable this behavior so you can still call IsItemHovered() on the source item.
	    SourceNoHoldToOpenOthers     = 1 << 2,       // Disable the behavior that allows to open tree nodes and collapsing header by holding over them while dragging a source item.
	    SourceAllowNullID            = 1 << 3,       // Allow items such as Text(), Image() that have no unique identifier to be used as drag source, by manufacturing a temporary identifier based on their window-relative position. This is extremely unusual within the dear imgui ecosystem and so we made it explicit.
	    SourceExtern                 = 1 << 4,       // External source (from outside of imgui), won't attempt to read current item/window info. Will always return true. Only one Extern source can be active simultaneously.
	    SourceAutoExpirePayload      = 1 << 5,   // Automatically expire the payload if the source cease to be submitted (otherwise payloads are persisting while being dragged)
			// AcceptDragDropPayload() flags
	    AcceptBeforeDelivery         = 1 << 10,      // AcceptDragDropPayload() will returns true even before the mouse button is released. You can then call IsDelivery() to test if the payload needs to be delivered.
	    AcceptNoDrawDefaultRect      = 1 << 11,      // Do not draw the default highlight rectangle when hovering over target.
			AcceptNoPreviewTooltip       = 1 << 12,  // Request hiding the BeginDragDropSource tooltip from the BeginDragDropTarget site.
	    AcceptPeekOnly               = EImGui_DragDropFlags.AcceptBeforeDelivery | EImGui_DragDropFlags.AcceptNoDrawDefaultRect  // For peeking ahead and inspecting the payload before delivery.
	};

#endregion

#region EImGui_Key
	enum EImGui_Key {
	    Tab,       // for tabbing through fields
	    LeftArrow, // for text edit
	    RightArrow,// for text edit
	    UpArrow,   // for text edit
	    DownArrow, // for text edit
	    PageUp,
	    PageDown,
	    Home,      // for text edit
	    End,       // for text edit
	    Delete,    // for text edit
	    Backspace, // for text edit
	    Enter,     // for text edit
	    Escape,    // for text edit
	    A,         // for text edit CTRL+A: select all
	    C,         // for text edit CTRL+C: copy
	    V,         // for text edit CTRL+V: paste
	    X,         // for text edit CTRL+X: cut
	    Y,         // for text edit CTRL+Y: redo
	    Z,         // for text edit CTRL+Z: undo
	    Insert,    // for text editor
		
	    Num
	};
#endregion
#region EImGui_Col
	//enum ImGuiCol_
	enum EImGui_Col {
	    Text,
	    TextDisabled,
	    WindowBg,              // Background of normal windows
	    ChildBg,               // Background of child windows
	    PopupBg,               // Background of popups, menus, tooltips windows
	    Border,
	    BorderShadow,
	    FrameBg,               // Background of checkbox, radio button, plot, slider, text input
	    FrameBgHovered,
	    FrameBgActive,
	    TitleBg,
	    TitleBgActive,
	    TitleBgCollapsed,
	    MenuBarBg,
	    ScrollbarBg,
	    ScrollbarGrab,
	    ScrollbarGrabHovered,
	    ScrollbarGrabActive,
	    CheckMark,
	    SliderGrab,
	    SliderGrabActive,
	    Button,
	    ButtonHovered,
	    ButtonActive,
	    Header,
	    HeaderHovered,
	    HeaderActive,
	    Separator,
	    SeparatorHovered,
	    SeparatorActive,
	    ResizeGrip,
	    ResizeGripHovered,
	    ResizeGripActive,
	    Tab,
	    TabHovered,
	    TabActive,
	    TabUnfocused,
	    TabUnfocusedActive,
	    PlotLines,
	    PlotLinesHovered,
	    PlotHistogram,
	    PlotHistogramHovered,
	    TextSelectedBg,
	    DragDropTarget,
	    NavHighlight,          // Gamepad/keyboard: current highlighted item
	    NavWindowingHighlight, // Highlight window when using CTRL+TAB
	    NavWindowingDimBg,     // Darken/colorize entire screen behind the CTRL+TAB window list, when active
	    ModalWindowDimBg,      // Darken/colorize entire screen behind a modal window, when one is active
 
	  Num
	};
#endregion
#region EImGui_StyleVar
	// ImGuiStyleVar
	enum EImGui_StyleVar
	{
	    // Enum name ......................// Member in ImGuiStyle structure (see ImGuiStyle for descriptions)
	   Alpha,               // float     Alpha
	   WindowPadding,       // ImVec2    WindowPadding
	   WindowRounding,      // float     WindowRounding
	   WindowBorderSize,    // float     WindowBorderSize
	   WindowMinSize,       // ImVec2    WindowMinSize
	   WindowTitleAlign,    // ImVec2    WindowTitleAlign
	   ChildRounding,       // float     ChildRounding
	   ChildBorderSize,     // float     ChildBorderSize
	   PopupRounding,       // float     PopupRounding
	   PopupBorderSize,     // float     PopupBorderSize
	   FramePadding,        // ImVec2    FramePadding
	   FrameRounding,       // float     FrameRounding
	   FrameBorderSize,     // float     FrameBorderSize
	   ItemSpacing,         // ImVec2    ItemSpacing
	   ItemInnerSpacing,    // ImVec2    ItemInnerSpacing
	   IndentSpacing,       // float     IndentSpacing
	   ScrollbarSize,       // float     ScrollbarSize
	   ScrollbarRounding,   // float     ScrollbarRounding
	   GrabMinSize,         // float     GrabMinSize
	   GrabRounding,        // float     GrabRounding
	   TabRounding,         // float     TabRounding
	   ButtonTextAlign,     // ImVec2    ButtonTextAlign
	   SelectableTextAlign, // ImVec2    SelectableTextAlign
    
	   Num
	};
#endregion
#region EImGui_ColorEditFlags
	// Enumeration for ColorEdit3() / ColorEdit4() / ColorPicker3() / ColorPicker4() / ColorButton()
	enum EImGui_ColorEditFlags
	{
	    None            = 0,
	    NoAlpha         = 1 << 1,   //              // ColorEdit, ColorPicker, ColorButton: ignore Alpha component (will only read 3 components from the input pointer).
	    NoPicker        = 1 << 2,   //              // ColorEdit: disable picker when clicking on colored square.
	    NoOptions       = 1 << 3,   //              // ColorEdit: disable toggling options menu when right-clicking on inputs/small preview.
	    NoSmallPreview  = 1 << 4,   //              // ColorEdit, ColorPicker: disable colored square preview next to the inputs. (e.g. to show only the inputs)
	    NoInputs        = 1 << 5,   //              // ColorEdit, ColorPicker: disable inputs sliders/text widgets (e.g. to show only the small preview colored square).
	    NoTooltip       = 1 << 6,   //              // ColorEdit, ColorPicker, ColorButton: disable tooltip when hovering the preview.
	    NoLabel         = 1 << 7,   //              // ColorEdit, ColorPicker: disable display of inline text label (the label is still forwarded to the tooltip and picker).
	    NoSidePreview   = 1 << 8,   //              // ColorPicker: disable bigger color preview on right side of the picker, use small colored square preview instead.
	    NoDragDrop      = 1 << 9,   //              // ColorEdit: disable drag and drop target. ColorButton: disable drag and drop source.

	    // User Options (right-click on widget to change some of them).
	    AlphaBar        = 1 << 16,  //              // ColorEdit, ColorPicker: show vertical alpha bar/gradient in picker.
	    AlphaPreview    = 1 << 17,  //              // ColorEdit, ColorPicker, ColorButton: display preview as a transparent color over a checkerboard, instead of opaque.
	    AlphaPreviewHalf= 1 << 18,  //              // ColorEdit, ColorPicker, ColorButton: display half opaque / half checkerboard, instead of opaque.
	    HDR             = 1 << 19,  //              // (WIP) ColorEdit: Currently only disable 0.0f..1.0f limits in RGBA edition (note: you probably want to use ImGuiColorEditFlags_Float flag as well).
	    DisplayRGB      = 1 << 20,  // [Display]    // ColorEdit: override _display_ type among RGB/HSV/Hex. ColorPicker: select any combination using one or more of RGB/HSV/Hex.
	    DisplayHSV      = 1 << 21,  // [Display]    // "
	    DisplayHex      = 1 << 22,  // [Display]    // "
	    Uint8           = 1 << 23,  // [DataType]   // ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0..255.
	    Float           = 1 << 24,  // [DataType]   // ColorEdit, ColorPicker, ColorButton: _display_ values formatted as 0.0f..1.0f floats instead of 0..255 integers. No round-trip of value via integers.
	    PickerHueBar    = 1 << 25,  // [Picker]     // ColorPicker: bar for Hue, rectangle for Sat/Value.
	    PickerHueWheel  = 1 << 26,  // [Picker]     // ColorPicker: wheel for Hue, triangle for Sat/Value.
	    InputRGB        = 1 << 27,  // [Input]      // ColorEdit, ColorPicker: input and output data in RGB format.
	    InputHSV        = 1 << 28,  // [Input]      // ColorEdit, ColorPicker: input and output data in HSV format.

	    // Defaults Options. You can set application defaults using SetColorEditOptions(). The intent is that you probably don't want to
	    // override them in most of your calls. Let the user choose via the option menu and/or call SetColorEditOptions() once during startup.
	    OptionsDefault = EImGui_ColorEditFlags.Uint8 | EImGui_ColorEditFlags.DisplayRGB | EImGui_ColorEditFlags.InputRGB | EImGui_ColorEditFlags.PickerHueBar,

	    // [Internal] Masks
	    _DisplayMask    = EImGui_ColorEditFlags.DisplayRGB     | EImGui_ColorEditFlags.DisplayHSV | EImGui_ColorEditFlags.DisplayHex,
	    _DataTypeMask   = EImGui_ColorEditFlags.Uint8          | EImGui_ColorEditFlags.Float,
	    _PickerMask     = EImGui_ColorEditFlags.PickerHueWheel | EImGui_ColorEditFlags.PickerHueBar,
	    _InputMask      = EImGui_ColorEditFlags.InputRGB       | EImGui_ColorEditFlags.InputHSV
	};
#endregion
#region EImGui_MouseCursor
	// Enumeration for GetMouseCursor()
	enum EImGui_MouseCursor
	{
	    None = -1,
	    Arrow = 0,
	    TextInput,         // When hovering over InputText, etc.
	    Move,              // Unused
	    ResizeNS,          // Unused
	    ResizeEW,          // When hovering over a column
	    ResizeNESW,        // Unused
	    ResizeNWSE,        // When hovering over the bottom-right corner of a window
	    Hand,              // (Unused by Dear ImGui functions. Use for e.g. hyperlinks)
	    Num
	};
#endregion
#region EImGui_Cond
	// Condition for imguigml_set_window_**(), imguigml_set_next_window***(), imguigml_set_next_tree_node***() functions
	// All those functions treat 0 as a shortcut to EImGui_Cond.Always. 
	//   Note: From the point of view of the user use this as an enum (don't combine multiple values into flags).
	enum EImGui_Cond
	{
	    Always        = 1 << 0,   // Set the variable
	    Once          = 1 << 1,   // Set the variable once per runtime session (only the first call with succeed)
	    FirstUseEver  = 1 << 2,   // Set the variable if the window has no saved data (if doesn't exist in the .ini file)
	    Appearing     = 1 << 3    // Set the variable if the window is appearing after being hidden/inactive (or the first time)
	};
#endregion

	// Drawing flags
#region EImGui_DrawCornerFlags
	enum EImGui_DrawCornerFlags
	{
	    TopLeft   = 1 << 0, // 0x1
	    TopRight  = 1 << 1, // 0x2
	    BotLeft   = 1 << 2, // 0x4
	    BotRight  = 1 << 3, // 0x8
	    Top       = EImGui_DrawCornerFlags.TopLeft  | EImGui_DrawCornerFlags.TopRight,  // 0x3
	    Bot       = EImGui_DrawCornerFlags.BotLeft  | EImGui_DrawCornerFlags.BotRight,  // 0xC
	    Left      = EImGui_DrawCornerFlags.TopLeft  | EImGui_DrawCornerFlags.BotLeft,   // 0x5
	    Right     = EImGui_DrawCornerFlags.TopRight | EImGui_DrawCornerFlags.BotRight,  // 0xA
	    All       = 0xF     // In your function calls you may use ~0 (= all bits sets) instead of ImDrawCornerFlags_All, as a convenience
	};
#endregion
#region EImGui_DrawlistFlagfs
	enum EImGui_DrawListFlags
	{
	    AntiAliasedLines = 1 << 0,
	    AntiAliasedFill  = 1 << 1,
			AllowVtxOffset   = 1 << 2   // Can emit 'VtxOffset > 0' to allow large meshes. Set when 'ImGuiBackendFlags_RendererHasVtxOffset' is enabled.
	};
#endregion

#region EImGuiText_Palette
	enum EImGuiText_Palette
	{
			Default = 0,
			Keyword,
			Number,
			String,
			CharLiteral,
			Punctuation,
			Preprocessor,
			Identifier,
			KnownIdentifier,
			PreprocIdentifier,
			Comment,
			MultiLineComment,
			Background,
			Cursor,
			Selection,
			ErrorMarker,
			Breakpoint,
			LineNumber,
			CurrentLineFill,
			CurrentLineFillInactive,
			CurrentLineEdge,
		
	    Num
	};
#endregion


	// internal
#region InternalMacros
#macro ImGuiGML_CommandBuffer        (0)
#macro ImGuiGML_VertexBuffer         (1)

#macro RousrCallBufferSize (4096)

#macro __Imgui_in  (__imguigml_wrapper_buffer())
#macro __Imgui_out (__imguigml_wrapper_buffer())

	enum EImGui_DisplayMode {
		GUIAspect = 0,
		View,
	
		Num,
	
		// Range of DrawGUI modes
		GUIModesStart = EImGui_DisplayMode.GUIAspect,
		GUIModesEnd   = EImGui_DisplayMode.GUIAspect,
	
		// Range of view modes (consistency, guys)
		ViewModesStart = EImGui_DisplayMode.View,
		ViewModesEnd   = EImGui_DisplayMode.View,	
	};

#endregion
#region ImGuiGMLPayload
#macro ImGuiGML_PayloadData (global.__imguigml_payloads)
	enum EImGuiGML_PayloadData {
		Payloads = 0,
		UserPayloads,
		PayloadID,
	
		Num
	}
#endregion

	// imgui internal
#region EImGui_ValType
	enum EImGui_ValType {
	  Bool = 0,
	  Int,
	  UnsignedInt,
	  Float,
  
	  Num
	};
#endregion
#region EImGui_TextCallbackData
	// Array Passed to the Text Callback, the Writeable params will be re-written back to ImGui!
	enum EImGui_TextCallbackData {
	  EventFlag = 0,
	  Flags,
	  ReadOnly,
  
	  StartData,
  
	  // Always, History, and Completion Data
	  Key = EImGui_TextCallbackData.StartData,
	  Text,         
	  TextMaxLength,     
	  CurPos,     
	  SelectionStart,
	  SelectionEnd,
  
	  Num,
  
	  // Charfilter
	  Char = EImGui_TextCallbackData.StartData,
  
	  NumCharFilter,
	};
#endregion



}
