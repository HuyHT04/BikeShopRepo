namespace BikeShop.Domain.Entities;

public sealed class Address
{
    public int Id { get; set; }
    public required string UserId { get; set; }
    public required string RecipientName { get; set; }
    public required string PhoneNumber { get; set; }
    public required string AddressLine { get; set; }
    public required string Ward { get; set; }
    public required string District { get; set; }
    public required string Province { get; set; }
    public bool IsDefault { get; set; }
}

public sealed class Cart
{
    public int Id { get; set; }
    public required string UserId { get; set; }
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public ICollection<CartItem> Items { get; set; } = [];
}

public sealed class CartItem
{
    public int Id { get; set; }
    public int CartId { get; set; }
    public int ProductVariantId { get; set; }
    public int Quantity { get; set; }
    public Cart Cart { get; set; } = null!;
    public ProductVariant ProductVariant { get; set; } = null!;
}
