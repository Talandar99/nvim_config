--some heretic stuff
return {
	"nvim-orgmode/orgmode",
	opts = {
		org_agenda_files = { "~/workspace/notes/*" },
		org_default_notes_file = "~/workspace/notes/0001_todo.org",
		org_agenda_span = "month", --default time span that is showed when open agenda
		win_split_mode = { "float", 0.8 },
		win_border = "rounded",
		org_hide_emphasis_markers = true, -- hide things like bold,italic etc
		org_time_stamp_rounding_minutes = 1,
		org_capture_templates = {
			c = {
				description = "Calendar event",
				template = "* %?\n  %^t",
				target = "~/workspace/notes/0002_calendar.org",
			},
		},
	},
}