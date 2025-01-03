return {
	{
		"NvChad/nvterm",
		enabled = false,
	},
	{
		"lewis6991/gitsigns.nvim",
		enabled = false,
	},
	{
		"stevearc/conform.nvim",
		-- enabled = false,
		event = "BufWritePre", -- uncomment for format on save
		opts = require("configs.conform"),
		cond = function()
			return not vim.g.vscode -- Exclude this plugin in VSCode
		end,
	},
	{
		"smoka7/hop.nvim",
		version = "*",
		opts = {
			keys = "etovxqpdygfblzhckisuran", -- Define the keys for hop
			-- Initialize the hop module and directions
			cond = function()
				return not vim.g.vscode -- Exclude this plugin in VSCode
			end,
		},
	},

	{
		"CRAG666/code_runner.nvim",
		config = true,
		cond = function()
			return not vim.g.vscode -- Exclude this plugin in VSCode
		end,
	},

	{
		"Mofiqul/vscode.nvim",
		cond = function()
			return not vim.g.vscode -- Exclude this plugin in VSCode
		end,
	},

	-- LSP Configuration
	{
		"neovim/nvim-lspconfig",

		cond = function()
			return not vim.g.vscode -- Exclude this plugin in VSCode
		end,
		config = function()
			local lspconfig = require("lspconfig")
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			mason.setup()
			mason_lspconfig.setup({
				ensure_installed = {}, -- Add language servers here if needed
			})

			mason_lspconfig.setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
						on_attach = function(_, bufnr)
							local bufopts = { noremap = true, silent = true, buffer = bufnr }
							vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
							vim.keymap.set("n", "L", vim.lsp.buf.hover, bufopts)
							vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
							vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, bufopts)
							vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, bufopts)
							vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
							vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
						end,
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
					})
				end,
			})
		end,
	},

	-- mason-lspconfig Configuration (Optional)
	{
		"williamboman/mason-lspconfig.nvim",

		cond = function()
			return not vim.g.vscode -- Exclude this plugin in VSCode
		end,
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {}, -- Add language servers here if needed
			})
		end,
	},

	-- Treesitter Configuration
	{
		"nvim-treesitter/nvim-treesitter",

		cond = function()
			return not vim.g.vscode -- Exclude this plugin in VSCode
		end,
		opts = {
			ensure_installed = { "lua", "html", "css", "json" }, -- Add languages to install
			highlight = { enable = true },
			indent = { enable = true },
		},
	},

	-- Mason Configuration
	{
		"williamboman/mason.nvim",
		cond = function()
			return not vim.g.vscode -- Exclude this plugin in VSCode
		end,
		opts = {
			ensure_installed = {}, -- Add tools like linters and formatters here if needed
		},
		config = function()
			require("mason").setup()
		end,
	},

	-- Global Autocompletion Configuration for all languages
	{
		"hrsh7th/nvim-cmp",
		cond = function()
			return not vim.g.vscode -- Exclude this plugin in VSCode
		end,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP completion source
			"hrsh7th/cmp-buffer", -- Buffer completion source
			"hrsh7th/cmp-path", -- Path completion source
			"L3MON4D3/LuaSnip", -- Snippet engine
			"saadparwaiz1/cmp_luasnip", -- Snippet completions
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item() -- Select the first item if completion menu is visible
							cmp.confirm({ select = true }) -- Automatically confirm the selection (like pressing Enter)
						else
							fallback() -- Default behavior (insert a tab character if no completion is visible)
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item() -- Move to the previous item if completion menu is visible
						else
							fallback() -- Default behavior (insert a tab character)
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- LSP source for all languages (including Java)
					{ name = "luasnip" }, -- Snippet source
				}, {
					{ name = "buffer" }, -- Buffer source (for autocomplete from open files)
				}),
			})
		end,
	},

	-- {"nvim-java/nvim-java"},
}
