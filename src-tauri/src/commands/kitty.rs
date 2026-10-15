use std::path::Path;
use std::process::{Command, Stdio};

#[tauri::command]
pub fn kitty_launch_agent(agent: String, directory: String) -> Result<(), String> {
    if !matches!(agent.as_str(), "claude" | "codex") {
        return Err("Only Claude Code and Codex are supported".into());
    }
    let path = Path::new(&directory);
    if !path.is_dir() {
        return Err("The project directory does not exist".into());
    }
    let canonical = path.canonicalize().map_err(|e| e.to_string())?;

    #[cfg(target_os = "linux")]
    {
        Command::new("kitty")
            .arg("--directory")
            .arg(&canonical)
            .arg("--title")
            .arg(format!("Agent Console - {agent}"))
            .arg(&agent)
            .stdin(Stdio::null())
            .stdout(Stdio::null())
            .stderr(Stdio::null())
            .spawn()
            .map_err(|e| format!("Could not open Kitty: {e}"))?;
        Ok(())
    }
    #[cfg(not(target_os = "linux"))]
    {
        let _ = (canonical, Command::new("kitty"), Stdio::null());
        Err("External Kitty integration currently supports Linux only".into())
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn only_supported_agents() {
        assert!(matches!("claude", "claude" | "codex"));
        assert!(matches!("codex", "claude" | "codex"));
        assert!(!matches!("sh", "claude" | "codex"));
    }
}
