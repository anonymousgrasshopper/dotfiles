return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = { "BufReadPre", "BufNewFile" },
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
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
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
          -- CHANGE THIS to your path!
          command = "/home/Antoine/.local/share/nvim/mason/bin/codelldb",
          args = {"--port", "${port}"},

          -- On windows you may have to uncomment this:
          --detached = false,
        }
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
      -- dap.adapters.cppdbg = {
      --   id = 'cppdbg',
      --   type = 'executable',
      --   command = 'C:\\absolute\\path\\to\\cpptools\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe',
      --   options = {
      --     detached = false
      --   }
      -- }
      -- dap.configurations.cpp = {
      --   {
      --     type = 'cppdbg';
      --     name = "Launch file";
      --     request = 'launch';
      --     program = function()
      --       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      --     end,
      --     cwd = '${workspaceFolder}',
      --     stopAtEntry = true,
      --   },
      --   {
      --     name = 'Attach to gdbserver :1234',
      --     type = 'cppdbg',
      --     request = 'launch',
      --     MIMode = 'gdb',
      --     miDebuggerServerAddress = 'localhost:1234',
      --     miDebuggerPath = '/usr/bin/gdb',
      --     cwd = '${workspaceFolder}',
      --     program = function()
      --       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      --     end,
      --   },
      -- }

      vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Toggle breakpoint at current line" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Start or continue debugging" })
    end,
  }
}
