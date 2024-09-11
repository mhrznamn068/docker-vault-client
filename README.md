# Vault Secrets Fetcher Sidecar
This Docker image is designed to run as a sidecar in Kubernetes deployments. It fetches secrets from HashiCorp Vault and can output the secrets as either a .json file or a .env file in key-value format.

## How It Works
This script fetches secrets from Vault using the specified Vault token, server, and secret path. The secrets are then stored in the desired format (JSON or key-value .env) in a specified output path.

## Features:
- Fetch secrets from HashiCorp Vault.
- Generate a .json or key-value .env file.
- Configurable output path and file names.
- Run in a Kubernetes sidecar setup for injecting secrets into your application.

## Usage
# 1. Environment Variables
The following environment variables are required to configure the behavior of the script:

- vault_token (string): The Vault token used for authentication.
- vault_server (string): The Vault server address (hostname or IP).
- vault_server_connection (string): The connection protocol (e.g., https).
- vault_api_version (string): The Vault API version (e.g., v1).
- vault_secret_path (string): The path to the secret in Vault. If leading or trailing slashes are provided, they will be automatically removed.
- output_to_file (boolean, default True): Determines whether to output secrets to a file.
- output_file_path (string, default /tmp): The directory path where the output file will be stored.
- output_file_name (string, default secrets): The name of the output file without the extension.
- json_to_env (boolean, default False): If set to True, converts the JSON secrets file to .env format.
- env_file_name (string, default secrets): The name of the .env file if json_to_env is True.

# 2. Commands
- gen-secret: This is the main command for fetching secrets from Vault and generating output files.

**Example**:

```bash
./fetch_secrets.sh gen-secret
```
- sh or bash: Execute shell commands if provided.

**Example**:

```bash
./fetch_secrets.sh bash
```

## Output Files
### JSON Output:
By default, the script fetches secrets from Vault and writes them to a JSON file at the location specified by output_file_path and output_file_name.

**Example:**

```bash
/tmp/secrets.json
```

### Environment Variable (.env) Output:
If json_to_env is set to True, the script converts the JSON secrets file into a key-value .env file format. The output is stored in the specified output_file_path with the name defined by env_file_name.

**Example:**

```bash
/tmp/secrets.env
```

## Example Kubernetes Sidecar Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: my-app-image
        envFrom:
          - fileRef: /tmp/.env
      - name: vault-secrets-fetcher
        image: vault-secrets-fetcher-image
        env:
          - name: vault_token
            value: "<your-vault-token>"
          - name: vault_server
            value: "<your-vault-server>"
          - name: vault_server_connection
            value: "https"
          - name: vault_api_version
            value: "v1"
          - name: vault_secret_path
            value: "path/to/your/secret"
          - name: output_to_file
            value: "True"
          - name: json_to_env
            value: "True"
        volumeMounts:
          - name: secret-volume
            mountPath: /tmp
      volumes:
      - name: secret-volume
        emptyDir: {}
```

## License
This project is licensed under the MIT License.

## Contributions
Feel free to open issues or pull requests if you'd like to contribute to this project.
