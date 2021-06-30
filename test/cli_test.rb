# frozen_string_literal: true
require "test_helper"

class CliTest < Minitest::Test
  def test_help
    out = capture(:stdout) do
      ThemeCheck::Cli.parse_and_run!(%w(--help))
    end

    assert_includes(out, "Usage: theme-check")
  end

  def test_check
    out = capture(:stdout) do
      assert_raises(ThemeCheck::Cli::Abort) do
        ThemeCheck::Cli.parse_and_run!([__dir__ + "/theme"])
      end
    end
    assert_includes(out, "files inspected")
  end

  def test_print
    out = capture(:stdout) do
      ThemeCheck::Cli.parse_and_run!([__dir__ + "/theme", '--print'])
    end

    assert_includes(out, <<~EXPECTED)
      SyntaxError:
        enabled: true
    EXPECTED
  end

  def test_config_flag
    storage = make_file_system_storage(
      ".theme-check.yml" => <<~YAML,
        SyntaxError:
          enabled: false
      YAML
    )

    out = capture(:stdout) do
      ThemeCheck::Cli.parse_and_run!([__dir__ + "/theme", "-C", storage.path(".theme-check.yml").to_s, '--print'])
    end

    assert_includes(out, <<~EXPECTED)
      SyntaxError:
        enabled: false
    EXPECTED
  end

  def test_check_with_category
    out = capture(:stdout) do
      assert_raises(ThemeCheck::Cli::Abort) do
        ThemeCheck::Cli.parse_and_run!([__dir__ + "/theme", "-c", "translation"])
      end
    end
    refute_includes(out, "liquid")
  end

  def test_check_with_exclude_category
    out = capture(:stdout) do
      assert_raises(ThemeCheck::Cli::Abort) do
        ThemeCheck::Cli.parse_and_run!([__dir__ + "/theme", "-x", "liquid"])
      end
    end
    refute_includes(out, "liquid")
  end

  def test_check_no_templates
    assert_raises(ThemeCheck::Cli::Abort, /^No templates found./) do
      silence_stream(STDOUT) do
        ThemeCheck::Cli.parse_and_run!([__dir__])
      end
    end
  end

  def test_list
    out = capture(:stdout) do
      ThemeCheck::Cli.parse_and_run!(%w(--list))
    end
    assert_includes(out, "LiquidTag:")
  end

  def test_auto_correct
    out = capture(:stdout) do
      assert_raises(ThemeCheck::Cli::Abort) do
        ThemeCheck::Cli.parse_and_run!([__dir__ + "/theme", "-a"])
      end
    end
    assert_includes(out, "corrected")
  end

  def test_init
    storage = make_file_system_storage
    out = capture(:stdout) do
      ThemeCheck::Cli.parse_and_run!([storage.root, "--init"])
    end
    assert_includes(out, "Writing new .theme-check.yml")
  end

  def test_init_abort_with_existing_config_file
    storage = make_file_system_storage(
      ".theme-check.yml" => <<~END,
        root: .
      END
    )
    assert_raises(ThemeCheck::Cli::Abort, /^.theme-check.yml already exists/) do
      ThemeCheck::Cli.parse_and_run!([storage.root, "--init"])
    end
  end

  private

  # Ported from active_support/testing/stream
  def silence_stream(stream)
    old_stream = stream.dup
    stream.reopen(IO::NULL)
    stream.sync = true
    yield
  ensure
    stream.reopen(old_stream)
    old_stream.close
  end

  # Ported from active_support/testing/stream
  def capture(stream)
    stream = stream.to_s
    captured_stream = Tempfile.new(stream)
    stream_io = eval("$#{stream}") # # rubocop:disable Security/Eval
    origin_stream = stream_io.dup
    stream_io.reopen(captured_stream)

    yield

    stream_io.rewind
    captured_stream.read
  ensure
    captured_stream.close
    captured_stream.unlink
    stream_io.reopen(origin_stream)
  end
end
