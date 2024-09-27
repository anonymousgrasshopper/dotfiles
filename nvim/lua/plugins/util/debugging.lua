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
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
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
            return vim.fn.input('Path to executable: ', vim.fn.fnamemodify(vim.fn.expand("%"), ":r") .. '.exe', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }

      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Start or continue debugging" })
      vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Toggle breakpoint at current line" })
      vim.keymap.set('n', '<leader>dov',  dap.step_over )
      vim.keymap.set('n', '<leader>din',  dap.step_into )
      vim.keymap.set('n', '<leader>dout',  dap.step_out )
      vim.keymap.set('n', '<leader>dr',  dap.repl.open )
      vim.keymap.set('n', '<leader>dl',  dap.run_last )
      vim.keymap.set({'n', 'v'}, '<leader>dh', function() require('dap.ui.widgets').hover() end )
      vim.keymap.set({'n', 'v'}, '<leader>dp', function() require('dap.ui.widgets').preview() end)
      vim.keymap.set('n', '<leader>df',
        function() local widgets = require('dap.ui.widgets')
          widgets.centered_float(widgets.frames)
        end
      )
      vim.keymap.set('n', '<leader>ds',
        function()
          local widgets = require('dap.ui.widgets')
          widgets.centered_float(widgets.scopes)
        end
      )
    end,
  },
}
