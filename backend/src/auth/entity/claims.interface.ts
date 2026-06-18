export interface Claims {
  user_id: number;
  iat?: number;  // issued at
  exp?: number;  // expiry
  iss?: string;  // issuer
}
