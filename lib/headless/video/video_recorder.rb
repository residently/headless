require 'tempfile'

class VideoRecorder
  def initialize(display, dimensions, options = {})
    raise Exception.new("ffmpeg not found on your system") unless CliUtil.application_exists?("Xvfb")

    @display = display
    @dimensions = dimensions

    @pid_file = "/tmp/.recorder_#{@display}-lock"
  end

  def start
    CliUtil.fork_process("ffmpeg -y -r 30 -g 600 -s #{@dimensions} -f x11grab -i :#{@display} -vcodec qtrle /tmp/ci.mov", @pid_file)
  end

  def stop_and_save(path)
    CliUtil.kill_process(@pid_file)
    FileUtils.cp("/tmp/ci.mov", path)
  end

  def stop_and_clear
    CliUtil.kill_process(@pid_file)
    FileUtils.rm("/tmp/ci.mov")
  end
end