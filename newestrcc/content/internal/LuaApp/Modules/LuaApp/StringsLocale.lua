
local StringsLocale = {}

StringsLocale.Keys = {
	SEARCH = "SEARCH",
	TURN_ON_CHAT = "TURN_ON_CHAT",
	PRIVACY_SETTINGS = "PRIVACY_SETTINGS",
	CANCEL = "CANCEL",
	CONFIRM = "CONFIRM",
	SEARCH_FOR_FRIENDS = "SEARCH_FOR_FRIENDS",
	SEE_MORE_FRIENDS = "SEE_MORE_FRIENDS",
	SEE_LESS_FRIENDS = "SEE_LESS_FRIENDS",
	NO_NETWORK_CONNECTION = "NO_NETWORK_CONNECTION",
	MAKE_FRIENDS_TO_CHAT = "MAKE_FRIENDS_TO_CHAT",
	THIS_MESSAGE_WAS_MODERATED = "THIS_MESSAGE_WAS_MODERATED",
	CHAT_GROUP_NAME = "CHAT_GROUP_NAME",
	NOTIFICATIONS = "NOTIFICATIONS",
	ADD_FRIENDS = "ADD_FRIENDS",
	LEAVE_GROUP = "LEAVE_GROUP",
	LEAVE_GROUP_MESSAGE = "LEAVE_GROUP_MESSAGE",
	STAY = "STAY",
	LEAVE = "LEAVE",
	REMOVE_USER = "REMOVE_USER",
	REMOVE_USER_CONFIRMATION_MESSAGE = "REMOVE_USER_CONFIRMATION_MESSAGE",
	REMOVE = "REMOVE",
	NOT_SET = "NOT_SET",
	CHAT = "CHAT",
	CHAT_DETAILS = "CHAT_DETAILS",
	NEW_CHAT_GROUP = "NEW_CHAT_GROUP",
	CHAT_INPUT_PLACEHOLDER = "CHAT_INPUT_PLACEHOLDER",
	OPTION = "OPTION",
	VIEW_PROFILE = "VIEW_PROFILE",
	REPORT_USER = "REPORT_USER",
	REMOVE_FROM_GROUP = "REMOVE_FROM_GROUP",
	GENERAL = "GENERAL",
	MEMBERS = "MEMBERS",
	FAILED_TO_RENAME_TITLE = "FAILED_TO_RENAME_TITLE",
	FAILED_TO_RENAME_MESSAGE = "FAILED_TO_RENAME_MESSAGE",
	GROUP_NAME_MODERATED = "GROUP_NAME_MODERATED",
	FAILED_TO_LEAVE_GROUP = "FAILED_TO_LEAVE_GROUP",
	FAILED_TO_LEAVE_GROUP_MESSAGE = "FAILED_TO_LEAVE_GROUP_MESSAGE",
	FAILED_TO_REMOVE_USER = "FAILED_TO_REMOVE_USER",
	FAILED_TO_REMOVE_USER_MESSAGE = "FAILED_TO_REMOVE_USER_MESSAGE",
	TOO_MANY_PEOPLE = "TOO_MANY_PEOPLE",
	NAME_THIS_CHAT_GROUP = "NAME_THIS_CHAT_GROUP",
	SAVE = "SAVE",
	SAVE_NEW_GROUP = "SAVE_NEW_GROUP",
	SAVE_ADDED_FRIENDS = "SAVE_ADDED_FRIENDS",
	OFFLINE = "OFFLINE",
	ONLINE = "ONLINE",
}

StringsLocale.Languages = {
	EN_US = "en-us",
}

StringsLocale.DefaultLanguage = StringsLocale.Languages.EN_US

StringsLocale.Content = {
	{

		key = StringsLocale.Keys.SEARCH,
		values = {
			[StringsLocale.Languages.EN_US] = "Search",
		},
		comment = "Placeholder text for most search input text boxes. Explains the functionality of the text box.",
	},
	{

		key = StringsLocale.Keys.TURN_ON_CHAT,
		values = {
			[StringsLocale.Languages.EN_US] = "To chat with friends, turn on chat in your Privacy Settings.",
		},
		comment = "Explains how to enable chat.",
	},
	{

		key = StringsLocale.Keys.PRIVACY_SETTINGS,
		values = {
			[StringsLocale.Languages.EN_US] = "Privacy Settings",
		},
		comment = "Label for button that opens the user's privacy settings.",
	},
	{

		key = StringsLocale.Keys.CANCEL,
		values = {
			[StringsLocale.Languages.EN_US] = "Cancel",
		},
		comment = "Used for buttons that cancel an action.",
	},
	{

		key = StringsLocale.Keys.CONFIRM,
		values = {
			[StringsLocale.Languages.EN_US] = "Okay",
		},
		comment = "Used for buttons that confirm an action or dismiss an informational pop-up.",
	},
	{

		key = StringsLocale.Keys.SEARCH_FOR_FRIENDS,
		values = {
			[StringsLocale.Languages.EN_US] = "Search for Friends",
		},
		comment = "Placeholder text when searching for friends.",
	},
	{

		key = StringsLocale.Keys.SEE_MORE_FRIENDS,
		values = {
			[StringsLocale.Languages.EN_US] = "See More ({NUMBER_OF_FRIENDS})",
		},
		comment = "Labels a button that expands a list of friends. NUMBER_OF_FRIENDS is the number of additional friends that will be shown.",
	},
	{

		key = StringsLocale.Keys.SEE_LESS_FRIENDS,
		values = {
			[StringsLocale.Languages.EN_US] = "See Less",
		},
		comment = "Labels a button that expands a list of friends. NUMBER_OF_FRIENDS is the number of additional friends that will be shown.",
	},
	{

		key = StringsLocale.Keys.NO_NETWORK_CONNECTION,
		values = {
			[StringsLocale.Languages.EN_US] = "Connecting...",
		},
		comment = "Informs the user that there is no network connection and data (conversations, etc.) can not be sent or received.",
	},
	{

		key = StringsLocale.Keys.MAKE_FRIENDS_TO_CHAT,
		values = {
			[StringsLocale.Languages.EN_US] = "Make friends in games to start chatting and playing together.",
		},
		comment = "Unless a user has friends, they won't be able to chat with anyone. This message informs players they need friends to chat and suggests playing games as a way to find friends.",
	},
	{

		key = StringsLocale.Keys.THIS_MESSAGE_WAS_MODERATED,
		values = {
			[StringsLocale.Languages.EN_US] = "This message was moderated and not sent.",
		},
		comment = "Shown to the user if a message is fully moderated and not sent to the other users in a conversation.",
	},
	{

		key = StringsLocale.Keys.CHAT_GROUP_NAME,
		values = {
			[StringsLocale.Languages.EN_US] = "Chat Group Name",
		},
		comment = "Label for the name of a conversation",
	},
	{

		key = StringsLocale.Keys.NOTIFICATIONS,
		values = {
			[StringsLocale.Languages.EN_US] = "Notifications",
		},
		comment = "Label for button that allows you to change settings for which notifications you get.",
	},
	{

		key = StringsLocale.Keys.ADD_FRIENDS,
		values = {
			[StringsLocale.Languages.EN_US] = "Add Friends",
		},
		comment = "Labels a button that allows you to add friends to a conversation.",
	},
	{

		key = StringsLocale.Keys.LEAVE_GROUP,
		values = {
			[StringsLocale.Languages.EN_US] = "Leave Group",
		},
		comment = "Labels action that allows a user to remove themself from a conversation.",
	},
	{

		key = StringsLocale.Keys.REMOVE_USER,
		values = {
			[StringsLocale.Languages.EN_US] = "Remove User",
		},
		comment = "Labels an action which removes another user (not the local user) from a conversation.",
	},
	{

		key = StringsLocale.Keys.REMOVE,
		values = {
			[StringsLocale.Languages.EN_US] = "Remove",
		},
		comment = "Labels the confirmation button for removing a user from a conversation."
	},
	{

		key = StringsLocale.Keys.LEAVE_GROUP_MESSAGE,
		values = {
			[StringsLocale.Languages.EN_US] = "You won't be able to keep chatting with this group.",
		},
		comment = "Message explaining that if they leave a chat group they will no longer be able to participate in chat.",
	},
	{

		key = StringsLocale.Keys.STAY,
		values = {
			[StringsLocale.Languages.EN_US] = "Stay",
		},
		comment = "Cancels the leave group action.",
	},
	{

		key = StringsLocale.Keys.LEAVE,
		values = {
			[StringsLocale.Languages.EN_US] = "Leave",
		},
		comment = "Confirms the leave group action.",
	},
	{

		key = StringsLocale.Keys.NOT_SET,
		values = {
			[StringsLocale.Languages.EN_US] = "Not Set",
		},
		comment = "Informs the user the title of a group conversation has not been set.",
	},
	{

		key = StringsLocale.Keys.CHAT,
		values = {
			[StringsLocale.Languages.EN_US] = "Chat",
		},
		comment = "Title of screen that shows list of conversations, which is the first screen that appears when chat is open.",
	},
	{

		key = StringsLocale.Keys.CHAT_DETAILS,
		values = {
			[StringsLocale.Languages.EN_US] = "Chat Details",
		},
		comment = "Title of screen that informs the user of a conversation's participants and title and allows them to edit these."
	},
	{

		key = StringsLocale.Keys.NEW_CHAT_GROUP,
		values = {
			[StringsLocale.Languages.EN_US] = "New Chat Group",
		},
		comment = "Title of screen where user can create a new chat group.",
	},
	{

		key = StringsLocale.Keys.CHAT_INPUT_PLACEHOLDER,
		values = {
			[StringsLocale.Languages.EN_US] = "Say something",
		},
		comment = "Text shown in chat input bar before user types anything.",
	},
	{

		key = StringsLocale.Keys.OPTION,
		values = {
			[StringsLocale.Languages.EN_US] = "Option",
		},
		comment = "Title of pop-up that shows list of user actions.",
	},
	{

		key = StringsLocale.Keys.VIEW_PROFILE,
		values = {
			[StringsLocale.Languages.EN_US] = "View Profile",
		},
		comment = "Label for button that allows user to view another user's profile.",
	},
	{

		key = StringsLocale.Keys.REPORT_USER,
		values = {
			[StringsLocale.Languages.EN_US] = "Report User",
		},
		comment = "Label for button that allows user to report another user for inappropriate behavior.",
	},
	{

		key = StringsLocale.Keys.REMOVE_FROM_GROUP,
		values = {
			[StringsLocale.Languages.EN_US] = "Remove from Group",
		},
		comment = "Label for button that allows a user to remove another user from a group conversation.",
	},
	{

		key = StringsLocale.Keys.GENERAL,
		values = {
			[StringsLocale.Languages.EN_US] = "General",
		},
		comment = "Labels section of group details screen with general information like group name.",
	},
	{

		key = StringsLocale.Keys.MEMBERS,
		values = {
			[StringsLocale.Languages.EN_US] = "Members",
		},
		comment = "Labels section of group details screen that lists participants.",
	},
	{

		key = StringsLocale.Keys.FAILED_TO_RENAME_TITLE,
		values = {
			[StringsLocale.Languages.EN_US] = "Failed to Rename Conversation",
		},
		comment = "Informs the user that a conversation could not be renamed.",
	},
	{

		key = StringsLocale.Keys.FAILED_TO_RENAME_MESSAGE,
		values = {
			[StringsLocale.Languages.EN_US] = "The conversation {EXISTING_NAME} could not be renamed to {NEW_NAME}.",
		},
		comment = "Informs the user that a conversation could not be renamed.",
	},
	{

		key = StringsLocale.Keys.GROUP_NAME_MODERATED,
		values = {
			[StringsLocale.Languages.EN_US] = "The chat group name you entered was moderated",
		},
		comment = "Informs the user that the name they tried to give a group was deemed inappropriate and moderated.",
	},
	{

		key = StringsLocale.Keys.FAILED_TO_LEAVE_GROUP,
		values = {
			[StringsLocale.Languages.EN_US] = "Failed to Leave Group",
		},
		comment = "Title of message when a user tries to leave a group and the http request fails.",
	},
	{

		key = StringsLocale.Keys.FAILED_TO_LEAVE_GROUP_MESSAGE,
		values = {
			[StringsLocale.Languages.EN_US] = "You could not be removed from the conversation {CONVERSATION_TITLE}.",
		},
		comment = "Message when a user tries to leave a group and the http request fails.",
	},
	{

		key = StringsLocale.Keys.FAILED_TO_REMOVE_USER,
		values = {
			[StringsLocale.Languages.EN_US] = "Failed to Remove User",
		},
		comment = "Title of message when a user tries to remove another user from a group and the http request fails.",
	},
	{

		key = StringsLocale.Keys.FAILED_TO_REMOVE_USER_MESSAGE,
		values = {
			[StringsLocale.Languages.EN_US] = "The user {USERNAME} could not be removed from the conversation {CONVERSATION_TITLE}.",
		},
		comment = "Title of message when a user tries to remove another user from a group and the http request fails.",
	},
	{

		key = StringsLocale.Keys.TOO_MANY_PEOPLE,
		values = {
			[StringsLocale.Languages.EN_US] = "You can only have up to {MAX_GROUP_SIZE} players in a chat group.",
		},
		comment = "Informs the user that they can't add any more friends to a conversation.",
	},
	{

		key = StringsLocale.Keys.NAME_THIS_CHAT_GROUP,
		values = {
			[StringsLocale.Languages.EN_US] = "Name this chat group",
		},
		comment = "Placeholder text for input field that allows user to name a new chat group",
	},
	{

		key = StringsLocale.Keys.SAVE_NEW_GROUP,
		values = {
			[StringsLocale.Languages.EN_US] = "Create",
		},
		comment = "Labels button that saves a new chat group.",
	},
	{

		key = StringsLocale.Keys.SAVE_ADDED_FRIENDS,
		values = {
			[StringsLocale.Languages.EN_US] = "Add",
		},
		comment = "Labels button that saves changes to chat group when adding new friends.",
	},
	{

		key = StringsLocale.Keys.SAVE,
		values = {
			[StringsLocale.Languages.EN_US] = "Save",
		},
		comment = "Labels button that confirms and saves a change",
	},
	{

		key = StringsLocale.Keys.REMOVE_USER_CONFIRMATION_MESSAGE,
		values = {
			[StringsLocale.Languages.EN_US] = "Are you sure you want to remove {USERNAME} from this chat group?",
		},
		comment = "Message asking user for confirmation before removing another user from a group conversation",
	},
	{

		key = StringsLocale.Keys.OFFLINE,
		values = {
			[StringsLocale.Languages.EN_US] = "Offline",
		},
		comment = "Informs the local user that another user is not signed onto the platform",
	},
	{

		key = StringsLocale.Keys.ONLINE,
		values = {
			[StringsLocale.Languages.EN_US] = "Online",
		},
		comment = "Informs the local user that another user is signed onto the platform",
	},
}

return StringsLocale