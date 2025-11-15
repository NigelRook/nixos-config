{ config, ... }:
{
  sops.secrets."homelab/cloudflare-token-b64" = {};
  sops.templates."cloudflare-token.yaml".content = ''
    apiVersion: v1
    kind: Secret
    metadata:
      name: cloudflare-api-token-secret
      namespace: cert-manager
    type: Opaque
    data:
      api-token: ${config.sops.placeholder."homelab/cloudflare-token-b64"}
  '';

  services.k3s = {
    manifests = {
      cert-manager-namespace.content = {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "cert-manager";
        };
      };
      cloudflare-api-token-secret.source = config.sops.templates."cloudflare-token.yaml".path;
    };
    autoDeployCharts = {
      argocd = {
        name = "argo-cd";
        repo = "https://argoproj.github.io/argo-helm";
        version = "9.1.3";
        hash = "sha256-OG74wEZuXyqT5S98lhj/E+t+KScJZycVWeLORPs8J7I=";
        values = {
          configs = {
            params = {
              "server.insecure" = true;
            };
          };
        };
      };
    };
  };
}
