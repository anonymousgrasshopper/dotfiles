return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handler = {
        ensure_installed = {
          "codelldb",
        }
      }
    },
  },
  {
    "mfussenegger/nvim-dap",
    lazy=true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    keys = {
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() require("dapui").close() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "ToggleUI", silent = false },
    },

    config = function()
      local dap   = require("dap")
      local dapui = require("dapui")

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      dapui.setup()

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "/home/Antoine/.local/share/nvim/mason/bin/codelldb",
          args = {"--port", "${port}"},
          -- On windows you may have to uncomment this:
           detached = false,
        }
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.fnamemodify(vim.fn.expand("%"), ":r") .. '.exe', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }

      vim.keymap.set('n', '<leader>dl',  dap.run_last )
      vim.keymap.set({'n', 'v'}, '<leader>dh', function() require('dap.ui.widgets').hover() end )
      vim.keymap.set({'n', 'v'}, '<leader>dp', function() require('dap.ui.widgets').preview() end)
      vim.keymap.set('n', '<leader>df',
        function() local widgets = require('dap.ui.widgets')
          widgets.centered_float(widgets.frames)
        end )
      vim.keymap.set('n', '<leader>ds',
        function()
          local widgets = require('dap.ui.widgets')
          widgets.centered_float(widgets.scopes)
        end )
    end,
  },
}
-- return {
--   {
--     "mfussenegger/nvim-dap",
--     cmd = { "DapContinue", "DapToggleBreakpoint" },
--     keys = { "<F5>", "<F8>", "<F9>", "<F10>",
--       -- { "<leader>dT", ":DapTerminate<cr>", desc = "Terminate", silent = false },
--       -- { "<leader>db", ":DapToggleBreakpoint<cr>", desc = "ToggleBreakpoint", silent = false },
--       -- { "<leader>dc", ":DapContinue<cr>", desc = "Continue", silent = false },
--       { "<leader>de", function() require("dapui").eval() end, desc = "EvalLine", silent = false },
--       { "<leader>dl", function() require("dap").run_last() end, desc = "RunLast", silent = false },
--       { "<leader>dn", ":DapStepOver<cr>", desc = "StepOver", silent = false },
--       { "<leader>do", ":DapStepOut<cr>", desc = "StepOut", silent = false },
--       { "<leader>dr", function() require("dap").restart() end, desc = "Restart", silent = false },
--       { "<leader>ds", ":DapStepInto<cr>", desc = "StepInto", silent = false },
--       { "<leader>dt",
--         function()
--           require("dap").terminate()
--           require("dapui").close()
--         end
--         , desc = "TerminateClose", silent = false },
--       { "<leader>du", function() require("dapui").toggle() end, desc = "ToggleUI", silent = false },
--     },
--     dependencies = {
--       "rcarriga/nvim-dap-ui",
--       "nvim-neotest/nvim-nio",
--       "jay-babu/mason-nvim-dap.nvim",
--       'theHamsta/nvim-dap-virtual-text',
--     },
--     config = function()
--       local dap, dapui = require("dap"), require("dapui")
--       dapui.setup({
--
--       })
--
--       -- external terminal
--       dap.defaults.fallback.force_external_terminal = true
--       -- alacritty
--       dap.defaults.fallback.external_terminal = {
--         command = "alacritty",
--         args = { "-e" },
--       }
--       -- tmux
--       dap.defaults.fallback.external_terminal = {
--         command = "tmux",
--         args = { "split-window", "-l", "25%" },
--       }
--
--       dap.listeners.after.event_initialized["dapui_config"] = function()
--         dapui.open()
--       end
--       -- dap.listeners.before.event_terminated["dapui_config"] = function()
--       --     dapui.close()
--       -- end
--       -- dap.listeners.before.event_exited["dapui_config"] = function()
--       --     dapui.close()
--       -- end
--       require("mason-nvim-dap").setup({
--         handlers = {},
--         ensure_installed = {
--           "codelldb",
--         }
--       })
--       vim.keymap.set("n", "<F5>", ":DapContinue<cr>", { silent = false, desc = "DapContinue" })
--       vim.keymap.set("n", "<F8>", ":DapStepInto<cr>", { silent = false, desc = "DapStepInto" })
--       vim.keymap.set("n", "<F9>", ":DapStepOut<cr>", { silent = false, desc = "DapStepOut" })
--       vim.keymap.set("n", "<F7>", ":DapStepOver<cr>", { silent = false, desc = "DapStepOver" })
--       require("nvim-dap-virtual-text").setup({
--
--       })
--       local signs = {
--         Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
--         Breakpoint = " ",
--         BreakpointCondition = " ",
--         BreakpointRejected = { " ", "DiagnosticError" },
--         LogPoint = ".>",
--       }
--       for name, sign in pairs(signs) do
--         sign = type(sign) == "table" and sign or { sign }
--         vim.fn.sign_define(
--           "Dap" .. name,
--           { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
--         )
--       end
--
--     end,
--   }
-- }
