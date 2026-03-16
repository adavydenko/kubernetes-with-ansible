# Translation Rules for Technical Documentation

Rules and guidelines for translating technical documentation while preserving code integrity.

## Never Translate

### Code and Commands
- All code in fenced blocks (```bash, ```yaml, ```json, etc.)
- Command names: `kubectl`, `ansible-playbook`, `docker`
- Command flags: `--output`, `-f`, `--all-namespaces`
- Command syntax and structure

### File System Elements
- File names: `config.yaml`, `deployment.yml`, `README.md`
- File paths: `/usr/local/bin`, `~/.kube/config`
- File extensions: `.yaml`, `.yml`, `.md`, `.sh`, `.json`
- Directory names in paths

### Variables and Identifiers
- Environment variables: `$HOME`, `$PATH`, `${VARIABLE}`
- Placeholders: `{variable}`, `<placeholder>`, `[optional]`
- YAML keys and structure
- JSON keys and structure
- Variable names in code

### Technical Identifiers
- Namespace names: `metallb-system`, `kube-system`
- Resource names: `nginx-demo-service`
- API endpoints and URLs
- Package names: `nginx`, `prometheus`, `metallb`

### Tool and Technology Names
- Tool names: kubectl, Ansible, MetalLB, Prometheus, Grafana
- Technology names: Kubernetes, Docker, Linux
- Acronyms: CNI, API, RBAC, DNS

## Always Translate

### Document Structure
- Document titles and headers
- Section descriptions
- Table headers (content, not structure)
- List items (text content)

### Instructions and Descriptions
- Step-by-step instructions
- Explanatory text
- Notes and warnings
- Error messages and troubleshooting text

### Comments in Code
- Comments in code blocks (when helpful for target language)
- Inline comments explaining code
- TODO comments and notes

## Context-Dependent Translations

### "Deployment"
- Process: "Развертывание" (deployment process)
- Kubernetes object: "Deployment" (keep in English in code context)

### "Service"
- General service: "Сервис" (general service)
- Kubernetes object: "Сервис" or "Service" (in code context)

### "Namespace"
- General: "Пространство имен"
- In code: Can use "Namespace" in technical contexts

## Translation Patterns

### Pattern 1: Command with Comment
```bash
# Original:
# Run the deployment command
kubectl apply -f deployment.yaml

# Translated:
# Выполните команду развертывания
kubectl apply -f deployment.yaml
```

### Pattern 2: Inline Code in Text
```markdown
# Original:
Edit the `config.yaml` file.

# Translated:
Отредактируйте файл `config.yaml`.
```

### Pattern 3: Configuration Block
```yaml
# Original:
# Configuration for MetalLB
metallb_ip_pool:
  start: "10.0.2.240"

# Translated:
# Конфигурация для MetalLB
metallb_ip_pool:
  start: "10.0.2.240"
```

## Markdown Preservation

- Preserve all Markdown syntax
- Keep code block language identifiers
- Maintain link structure (translate text, preserve URLs)
- Preserve table structure (translate content)
- Keep heading hierarchy

## Link Handling

- Translate link text to match translated headers
- Preserve relative paths
- Update anchor links if headers changed
- Keep external URLs unchanged

## Quality Checks

After translation, verify:
1. All code blocks are intact
2. Commands are still executable
3. File paths are unchanged
4. Markdown syntax is valid
5. Terminology is consistent
6. Links work correctly

