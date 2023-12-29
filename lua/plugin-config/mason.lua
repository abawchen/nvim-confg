local status, null_ls = pcall(require, "null-ls")
if not status then
	vim.notify("null-ls not found")
	return
end

local status, mason = pcall(require, "mason")
if not status then
	vim.notify("mason not found")
	return
end

mason.setup({
	ensure_installed = {
		"pyright",
		"gopls",
		"jdtls",
		"lua-language-server",
	},
})

local status, mason_null_ls = pcall(require, "mason-null-ls")
if not status then
	vim.notify("mason-null-ls not found")
	return
end

mason_null_ls.setup({
	ensure_installed = {
		"jq",
		"stylua",
		"gofumpt",
		"golines",
		-- "goimports",
		-- "gomodifytags",
		-- python
		-- "autoflake",
		-- "black",
		-- "isort",
	},
	-- handlers = {
	-- 	function() end,
	-- 	golines = function(source_name, methods)
	-- 		local a = null_ls.builtins.formatting.golines.with({
	-- 			extra_args = { "-m", 120 },
	-- 		})
	-- 		null_ls.register(a)
	-- 	end,
	-- },
})

-- https://www.reddit.com/r/neovim/comments/y9qv1w/autoformatting_on_save_with_vimlspbufformat_and/
-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
null_ls.setup({
	debug = true,
	sources = {
		null_ls.builtins.formatting.black.with({
			extra_args = { "--line-length=120" },
		}),
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.autoflake.with({
			extra_args = { "-i", "--remove-unused-variables", "--remove-all-unused-imports" },
		}),
		null_ls.builtins.formatting.jq,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.sqlformat,
		null_ls.builtins.formatting.golines.with({
			extra_args = { "-m", 120 },
		}),
		null_ls.builtins.formatting.goimports,
		-- XXX: leave gofumpt in basic.lua
		-- null_ls.builtins.formatting.gofumpt,

		-- null_ls.builtins.completion.spell,
		-- null_ls.builtins.diagnostics.flake8,
	},
	-- on_attacha = function(client, bufnr)
	-- 	vim.notify("mason-null-ls not found")
	-- 	vim.lsp.buf.format({ async = false })
	-- 	if client.supports_method("textDocument/formatting") then
	-- 		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
	-- 		vim.api.nvim_create_autocmd("BufWritePre", {
	-- 			group = augroup,
	-- 			buffer = bufnr,
	-- 			callback = function()
	-- 				vim.lsp.buf.format({ async = false })
	-- 				-- vim.lsp.buf.format()
	-- 			end,
	-- 		})
	-- 	end
	-- end,
})

-- -- local lspconfig = require("lspconfig")
-- local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
--
-- lspconfig.gopls.setup({
-- 	capabilities = lsp_capabilities,
-- 	-- https://stackoverflow.com/a/73289654
-- 	-- on_attach = require("cmp").on_attach,
-- 	settings = {
-- 		gopls = {
-- 			buildFlags = { "-tags=ems bsc cht rakuten taipower wireinject" },
-- 		},
-- 	},
-- })
-- lspconfig.pyright.setup({
-- 	capabilities = lsp_capabilities,
-- })
-- lspconfig.jdtls.setup({
-- 	capabilities = lsp_capabilities,
-- })

-- XXX: it works!
-- https://neovim.discourse.group/t/lsp-formatting-doesnt-always-work/1884/20
vim.api.nvim_create_augroup("LspFormatting", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	group = "LspFormatting",
	callback = function()
		vim.lsp.buf.format({
			timeout_ms = 2000,
			filter = function(clients)
				return vim.tbl_filter(function(client)
					return pcall(function(_client)
						return _client.config.settings.autoFixOnSave or false
					end, client) or false
				end, clients)
			end,
		})
	end,
})
