return {
	"hmdfrds/focal.nvim",
	event = "VeryLazy",
	config = function(_, opts)
	local focal = require("focal")
	focal.setup(opts)
	focal.disable()
	local oil_preview_active = false
		local focal_was_enabled = false
		local function sync_oil_preview()
			local oil = package.loaded["oil.util"]
			if not oil then
				return
			end

			local active = oil.get_preview_win() ~= nil
			if active and not oil_preview_active then
				oil_preview_active = true
				focal_was_enabled = focal.is_enabled()
				focal.disable()
			elseif not active and oil_preview_active then
				oil_preview_active = false
				if focal_was_enabled then
					focal.enable()
				end
			end
		end

		vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "WinClosed" }, {
			group = vim.api.nvim_create_augroup("FocalOilPreview", { clear = true }),
			callback = function()
				vim.schedule(sync_oil_preview)
			end,
		})

		local function register_script_renderer(
			name,
			extensions,
			script_name,
			dependency,
			fit_to_window,
			use_window_size
		)
			local process
			local preview_script = vim.fn.stdpath("config") .. "/oil-preview/" .. script_name
			local function clear()
				if process then
					process:kill(15)
					process = nil
				end
			end

			focal.register_renderer({
				name = name,
				extensions = extensions,
				priority = 60,
				needs_terminal = true,
				is_available = function()
					return vim.fn.executable("python3") == 1
						and vim.fn.executable(dependency) == 1
						and vim.fn.executable("chafa") == 1
						and vim.fn.filereadable(preview_script) == 1
				end,
				get_geometry = function(_, _, env)
					if not fit_to_window then
						return { width = env.max_width, height = env.max_height }
					end

					local width = env.max_width
					local cursor = vim.api.nvim_win_get_cursor(0)
					local screen_pos = vim.fn.screenpos(0, cursor[1], cursor[2] + 1)
					if screen_pos.col > 0 then
						local margin = env.config.border == "none" and 0 or 2
						local cursor_col = screen_pos.col - 1
						local space_right = vim.o.columns - cursor_col - env.config.col_offset - 1 - margin
						local space_left = cursor_col - env.config.col_offset - margin
						local available = math.max(space_right, space_left)
						if available > 0 then
							width = math.min(width, available)
						end
					end
					return { width = width, height = env.max_height }
				end,
				render = function(ctx, done)
					clear()
					local current_process
					local width = use_window_size and vim.api.nvim_win_get_width(ctx.win) or ctx.geometry.width
					local height = use_window_size and vim.api.nvim_win_get_height(ctx.win) or ctx.geometry.height
					current_process = vim.system({
						"python3",
						preview_script,
						ctx.path,
						tostring(width),
						tostring(height),
					}, { text = true }, function(result)
						vim.schedule(function()
							if process ~= current_process then
								return
							end
							process = nil

							if result.code ~= 0 or result.stdout == "" then
								done(false)
								return
							end

							local sent = pcall(vim.api.nvim_chan_send, ctx.chan, result.stdout)
							if not sent then
								done(false)
								return
							end

							if not fit_to_window then
								done(true, { output = result.stdout })
								return
							end

							local line_count = 0
							local max_width = 0
							for line in result.stdout:gmatch("[^\n]+") do
								line_count = line_count + 1
								local visible = line:gsub("\27%[[%d;]*[mB]", "")
								max_width = math.max(max_width, vim.fn.strdisplaywidth(visible))
							end
							local fit = {
								width = max_width > 0 and math.min(max_width, ctx.geometry.width) or ctx.geometry.width,
								height = line_count > 0 and math.min(line_count, ctx.geometry.height)
									or ctx.geometry.height,
							}

							done(true, { output = result.stdout, fit = fit })
						end)
					end)
					process = current_process
				end,
				clear = clear,
				cleanup = clear,
			})
		end

		local function find_blender_thumbnailer()
			local path = vim.fn.exepath("blender-thumbnailer")
			if path ~= "" then
				return path
			end

			local paths = vim.fn.glob("/opt/blender-bin-*/blender-thumbnailer", false, true)
			table.sort(paths)
			return paths[#paths] or ""
		end

		register_script_renderer("oil-stl", { "stl", "3mf" }, "stl_preview.py", "openscad")
		register_script_renderer("oil-bgcode", { "bgcode" }, "bgcode_preview.py", "bgcode", true, true)
		register_script_renderer("oil-pdf", { "pdf" }, "pdf_preview.py", "pdftotext", true, true)
		register_script_renderer("oil-html", { "html", "htm", "xhtml" }, "html_preview.py", "w3m", true, true)
		register_script_renderer(
			"oil-image",
			{ "png", "jpg", "jpeg", "webp", "gif", "bmp", "tiff", "tif", "avif", "svg" },
			"image_preview.py",
			"chafa",
			true,
			true
		)
		register_script_renderer("oil-aseprite", { "ase", "aseprite" }, "aseprite_preview.py", "aseprite", true, true)
		register_script_renderer("oil-media", {
			"wav",
			"mp3",
			"flac",
			"m4a",
			"wma",
			"ape",
			"ac3",
			"oga",
			"ogg",
			"ogx",
			"spx",
			"opus",
			"aac",
			"mpga",
			"avi",
			"mp4",
			"wmv",
			"dat",
			"3gp",
			"ogv",
			"mkv",
			"mpg",
			"mpeg",
			"vob",
			"fli",
			"flc",
			"flv",
			"m2v",
			"mov",
			"webm",
			"mts",
			"m4v",
			"ram",
			"qt",
			"divx",
			"asf",
			"asx",
			"unknown_video",
		}, "media_preview.py", "ffprobe", true, true)
		register_script_renderer("oil-torrent", { "torrent" }, "torrent_preview.py", "python3", true, true)
		register_script_renderer("oil-doc", { "doc" }, "document_preview.py", "libreoffice25.8", true, true)
		register_script_renderer("oil-docx", { "docx" }, "document_preview.py", "pandoc", true, true)
		register_script_renderer(
			"oil-spreadsheet",
			{ "xls", "xlsx", "xlsm", "xlsb", "ods" },
			"spreadsheet_preview.py",
			"libreoffice25.8",
			true,
			true
		)
		register_script_renderer(
			"oil-man",
			{ "1", "2", "3", "4", "5", "6", "7", "8" },
			"man_preview.py",
			"man",
			true,
			true
		)
		register_script_renderer(
			"oil-blend",
			{ "blend", "blend1" },
			"blend_preview.py",
			find_blender_thumbnailer(),
			true,
			true
		)
	end,
	opts = {
		max_file_size_mb = 100,
		min_width = 60,
		min_height = 60,
		max_width = 60,
		max_height = 60,
		max_width_percent = 60,
		max_height_percent = 90,
		row_offset = 100,
		col_offset = 60,
	},
}
