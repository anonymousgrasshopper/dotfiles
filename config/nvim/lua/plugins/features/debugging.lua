vim.g.maplocalleader = ','

local escape_spaces = function(path)
  local skip_next = false
  local nb_added_chars = 0
  for i = 1, 2 * path:len() + 1 do
    if i > path:len() then
      return path
    end
    if not skip_next then
      if path:sub(i, i) == ' ' then
        path = path:sub(1, i - 1) .. "\\" .. path:sub(i, path:len() + nb_added_chars)
        skip_next = true
        nb_added_chars = nb_added_chars + 1
      end
    else
      skip_next = false
    end
  end
end

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
  },
  cmd = { "DapContinue", "DapToggleBreakpoint" },
  keys = {
    { "<leader>dbg", function() return "<cmd>!codelldb_stdio_redirection ".. escape_spaces(vim.fn.fnamemodify(vim.fn.expand("%"), ":p:r")) .. "<CR>" .. "<cmd>!nohup clang++ -fstandalone-debug --debug " .. escape_spaces(vim.fn.expand("%")) .. " -o " .. escape_spaces(vim.fn.fnamemodify(vim.fn.expand("%"), ":r")) .. ".exe &<CR><CR>" end, expr = true, ft = "cpp" },
    { "<localleader>dbg", function() return "<cmd>!codelldb_stdio_redirection ".. escape_spaces(vim.fn.fnamemodify(vim.fn.expand("%"), ":p:r")) .. "<CR>" .. "<cmd>!nohup clang++ -fstandalone-debug --debug " .. escape_spaces(vim.fn.expand("%")) .. " -o " .. escape_spaces(vim.fn.fnamemodify(vim.fn.expand("%"), ":r")) .. ".exe &<CR><CR>" end, expr = true, ft = "cpp" },
    { "<leader>rm", function() return "<cmd>!remove_codelldb_stdio_redirection ".. escape_spaces(vim.fn.fnamemodify(vim.fn.expand("%"), ":p:r")) .. "<CR><CR>" end, expr = true, ft = "cpp" },
    { "<localleader>rm", function() return "<cmd>!remove_codelldb_stdio_redirection ".. escape_spaces(vim.fn.fnamemodify(vim.fn.expand("%"), ":p:r")) .. "<CR><CR>" end, expr = true, ft = "cpp" },

    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dt", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
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
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle repl" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dT", function() require("dap").terminate() require("dapui").close() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    { "<leader>dw", function() require("dap.ui.widgets").preview() end, desc = "Preview widgets" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle ui", silent = false },
    { "<leader>dR", function() require("dap").restart() end, desc = "Restart", silent = false },
    { "<leader>de", function() require("dapui").eval() end, desc = "Eval line", silent = false },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run last", silent = false },
  },

  config = function()
    local dap   = require("dap")
    local dapui = require("dapui")
    local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:r")

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
        command = vim.env.HOME .. "/.local/share/nvim/mason/bin/codelldb",
        args = {"--port", "${port}"},
        -- detached = false,
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
        stdio = { path .. ".input", path .. ".output", path .. ".errors"},
      },
    }

    local signs = {
      Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint = " ",
      BreakpointCondition = " ",
      BreakpointRejected = { " ", "DiagnosticError" },
      LogPoint = ".>",
    }
    for name, sign in pairs(signs) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
    end

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
}
