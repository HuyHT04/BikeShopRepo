using BikeShop.Domain.Enums;

namespace BikeShop.Domain.Entities;

public sealed class Order
{
    public long Id { get; set; }
    public required string OrderCode { get; set; }
    public required string UserId { get; set; }
    public OrderStatus Status { get; set; } = OrderStatus.Pending;
    public required string RecipientName { get; set; }
    public required string PhoneNumber { get; set; }
    public required string ShippingAddress { get; set; }
    public decimal Subtotal { get; set; }
    public decimal ShippingFee { get; set; }
    public decimal TotalAmount { get; set; }
    public string? CustomerNote { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public ICollection<OrderItem> Items { get; set; } = [];
    public ICollection<OrderStatusHistory> StatusHistories { get; set; } = [];
}

public sealed class OrderItem
{
    public long Id { get; set; }
    public long OrderId { get; set; }
    public int ProductVariantId { get; set; }
    public required string ProductName { get; set; }
    public required string Sku { get; set; }
    public string? VariantDescription { get; set; }
    public decimal UnitPrice { get; set; }
    public int Quantity { get; set; }
    public decimal LineTotal { get; set; }
    public Order Order { get; set; } = null!;
    public ProductVariant ProductVariant { get; set; } = null!;
}

public sealed class OrderStatusHistory
{
    public long Id { get; set; }
    public long OrderId { get; set; }
    public OrderStatus OldStatus { get; set; }
    public OrderStatus NewStatus { get; set; }
    public string? Note { get; set; }
    public string? ChangedByUserId { get; set; }
    public DateTime ChangedAt { get; set; } = DateTime.UtcNow;
    public Order Order { get; set; } = null!;
}
