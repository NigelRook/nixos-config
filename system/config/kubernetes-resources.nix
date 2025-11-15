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

  sops.secrets."homelab/argocd-secret-data" = {};
  sops.templates."argocd-secret.yaml".content = ''
    apiVersion: v1
    kind: Secret
    metadata:
      name: argocd-secret
      namespace: argocd
    type: Opaque
    ${config.sops.placeholder."homelab/argocd-secret-data"}
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

      argocd-namespace.content = {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "argocd";
        };
      };
      argocd-secret.source = config.sops.templates."argocd-secret.yaml".path;
      argocd-apps.content = {
        apiVersion = "argoproj.io/v1alpha1";
        kind = "Application";
        "metadata" = {
          name = "apps";
          namespace = "argocd";
          finalizers = [ "resources-finalizer.argocd.argoproj.io" ];
        };
        spec = {
          destination = {
            server = "https://kubernetes.default.svc";
            namespace = "argocd";
          };
          project = "default";
          source = {
            repoURL = "https://github.com/NigelRook/argo";
            targetRevision = "main";
            path = "apps";
          };
        };
      };
    };

    autoDeployCharts = {
      argocd = {
        name = "argo-cd";
        repo = "https://argoproj.github.io/argo-helm";
        version = "9.1.3";
        hash = "sha256-OG74wEZuXyqT5S98lhj/E+t+KScJZycVWeLORPs8J7I=";
        targetNamespace = "argocd";
        values = {
          configs = {
            params = {
              "server.insecure" = true;
            };
            secret.createSecret = false;
          };
        };
      };
    };
  };
}
