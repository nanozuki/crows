-- definition and default of global variables
local globals = {}

---@class LspConfig
---@field keys table<string, LspKeyMapper>
---@field on_attach_hooks LspOnAttachHook[]
---@field cap_makers LspCapabilitiesMaker[]
---@field servers table<string, LangServerConfig>
---@field setup fun(server_name:string)
---@field make_config fun(server_name:string):table

---@alias LspOnAttachHook fun(client:table,bufnr:number)
---@alias LspCapabilitiesMaker fun(caps:table):table

---@class LspKeyMapper
---@field [1] string key
---@field [2] string|function command
---@field [3] string description

---@class LangServerConfig: table
---@field lazyload? boolean when lazyload = true, lsp server won't be setup by nvim-lspconfig
---@field root_patterns? string[] see lspconfig.util.root_pattern
---@field config? table<string, any> lsp config
---@field on_attach? LspOnAttachHook additional on_attach function

local function list_workspace_folders()
  vim.print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end

local function toogle_inlay_hint()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.lsp.inlay_hint.enable(not enabled)
end

---@type LspConfig
globals.lsp = {
  keys = {
    goto_decl = { 'gD', vim.lsp.buf.declaration, 'Goto declaration' },
    goto_def = { 'gd', vim.lsp.buf.definition, 'Goto definition' },
    hover = { 'K', vim.lsp.buf.hover, 'Display hover information' },
    goto_impl = { 'gi', vim.lsp.buf.implementation, 'Goto implementation' },
    sign_help = { '<C-k>', vim.lsp.buf.signature_help, 'Display signature information' },
    add_folder = { '<leader>wa', vim.lsp.buf.add_workspace_folder, 'Add workspace folder' },
    del_folder = { '<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder' },
    list_folders = { '<leader>wl', list_workspace_folders, 'List workspace folder' },
    type_def = { '<leader>D', vim.lsp.buf.type_definition, 'Goto type definition' },
    rename = { '<leader>rn', vim.lsp.buf.rename, 'Rename symbol' },
    code_action = { '<leader>ca', vim.lsp.buf.code_action, 'Code action' },
    codelens = { '<leader>cl', vim.lsp.codelens.run, 'Code action' },
    list_ref = { 'gr', vim.lsp.buf.references, 'List references' },
    format = { '<leader>bf', vim.lsp.buf.format, 'Format buffer' },
    inlay_hint = { '<leader>lh', toogle_inlay_hint, 'Toogle in[l]ay [h]int' },
  },
  on_attach_hooks = {
    -- set buffer keymapping
    function(_, bufnr)
      for _, mapper in pairs(globals.lsp.keys) do
        vim.keymap.set('n', mapper[1], mapper[2], { desc = mapper[3], buffer = bufnr })
      end
    end,
  },
  cap_makers = {
    -- neovim default capabilities
    function(_)
      return vim.lsp.protocol.make_client_capabilities()
    end,
  },
  setup = function(_) end,
  make_config = function(_)
    return {}
  end,
  servers = {
    astro = {},
    cssls = {
      config = {
        lint = {
          unknownAtRules = 'ignore',
        },
      },
    },
    denols = {
      root_patterns = { 'deno.json', 'deno.jsonc' }, -- remove '.git' to avoid setup in node project
      config = {
        init_options = {
          enable = true,
          lint = true,
          unstable = true,
        },
      },
    },
    gleam = {},
    gopls = {
      config = {
        settings = {
          gopls = {
            gofumpt = globals.settings().use_gofumpt,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      },
      on_attach = function(_, bufnr)
        vim.keymap.set('n', '<leader>oi', function()
          vim.lsp.buf.code_action({
            context = { diagnostics = {}, only = { 'source.organizeImports' } },
            apply = true,
          })
        end, { desc = 'Organize imports', buffer = bufnr })
      end,
    },
    html = {},
    jsonls = {},
    lua_ls = {
      config = {
        settings = {
          Lua = {
            format = { enable = false },
            hint = { enable = true },
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      },
    },
    nil_ls = {},
    ocamllsp = {},
    pyright = {},
    ruff = {},
    rust_analyzer = {
      config = {
        settings = {
          ['rust-analyzer'] = {
            diagnostics = {
              diagnostics = { disabled = { 'unresolved-proc-macro' } },
              checkOnSave = { command = 'clippy' },
            },
          },
        },
      },
    },
    svelte = {
      on_attach = function(client, _)
        vim.api.nvim_create_autocmd('BufWritePost', {
          pattern = { '*.js', '*.ts' },
          callback = function(ctx)
            client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.match })
          end,
        })
      end,
    },
    tailwindcss = {
      config = {
        filetypes = { 'html', 'css', 'javascriptreact', 'typescriptreact', 'svelte' },
      },
    },
    terraformls = {},
    tsserver = {
      root_patterns = { 'tsconfig.json', 'jsconfig.json', 'package.json' }, -- remove '.git' to avoid setup in deno project
      config = { single_file_support = false },
    },
    tinymist = {},
    yamlls = {},
    zls = {},
  },
}


return globals
