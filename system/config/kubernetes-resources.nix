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

  sops.secrets.argocd-secret = {
    sopsFile = ../secrets/k8s/argocd-secret.yaml;
    key = "";
  };

  sops.secrets.argo-git-ssh = {
    sopsFile = ../secrets/k8s/argo-git-ssh.yaml;
    key = "";
  };

  sops.secrets."homelab/smtp-password" = {};
  sops.templates."alert-manager-creds.yaml".content = ''
    apiVersion: v1
    kind: Secret
    metadata:
      name: alert-manager-creds
      namespace: monitoring
    type: Opaque
    stringData:
      smtp-password: ${config.sops.placeholder."homelab/smtp-password"}
  '';

  sops.secrets.authelia-secrets = {
    sopsFile = ../secrets/k8s/authelia-secrets.yaml;
    key = "";
  };

  sops.secrets.authelia-oidc = {
    sopsFile = ../secrets/k8s/authelia-oidc.yaml;
    key = "";
  };

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
      argocd-secret.source = config.sops.secrets.argocd-secret.path;
      argo-git-ssh.source = config.sops.secrets.argo-git-ssh.path;
      argocd-apps.content = {
        apiVersion = "argoproj.io/v1alpha1";
        kind = "Application";
        "metadata" = {
          name = "bootstrap";
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
            repoURL = "git@github.com:NigelRook/argo.git";
            targetRevision = "main";
            path = "bootstrap";
          };
        };
      };

      monitoring-namespace.content = {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "monitoring";
        };
      };
      alert-manager-creds.source = config.sops.templates."alert-manager-creds.yaml".path;

      authelia-namespace.content = {
        apiVersion = "v1";
        kind = "Namespace";
        metadata = {
          name = "authelia";
        };
      };
      authelia-secrets.source = config.sops.secrets.authelia-secrets.path;
      authelia-oidc.source = config.sops.secrets.authelia-oidc.path;
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
